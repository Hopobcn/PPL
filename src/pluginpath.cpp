// Copyright (C) 2008-2011 by Philipp Muenzel. All rights reserved
// Released under the terms of the GNU Lesser General Public License
// as published by the Free Software Foundation, Inc.

#include <string>
#include <cstring>

#include "XPLMUtilities.h"
#include "XPLMPlanes.h"

#include "pluginpath.h"

using namespace PPL;

std::string PluginPath::plugin_directory = "";

///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////

std::string PluginPath::prependPluginPath(const std::string& file)
{
#ifdef BUILD_FOR_STANDALONE
    return file;
#else
    if (plugin_directory == "")
        throw PathSetupError("Critical error - no plugin name set - unable to create file in the right directory");
    char path[512];
    XPLMGetSystemPath(path);
    std::string absolute_path(path);
    absolute_path.
            append("Resources").append(XPLMGetDirectorySeparator()).
            append("plugins").append(XPLMGetDirectorySeparator()).
            append(plugin_directory).append(XPLMGetDirectorySeparator()).
            append(file);
#if APL && __MACH__
    int result = ConvertPath(absolute_path.c_str(), path, 512);
    if (result == 0)
        return std::string(path);
    else
        throw PathSetupError("Critical error - cannot convert Mac-HFS-format path to unix-format path");
#endif
    return absolute_path;
#endif
}

std::string PluginPath::prependPluginResourcesPath(const std::string& file)
{
    std::string res_path("Resources");
#ifdef BUILD_FOR_STANDALONE
    res_path.append("/");
    res_path.append(file);
    return res_path;
#else
    res_path.append(XPLMGetDirectorySeparator());
    res_path.append(file);
    return prependPluginPath(res_path);
#endif
}

///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////

std::string PluginPath::prependPlanePath(const std::string& file)
{
#ifdef BUILD_FOR_STANDALONE
    return file;
#else
    char name[512];
    char path[512];
    XPLMGetNthAircraftModel(0, name, path);
    std::string absolute_path(path);
    std::size_t pos = absolute_path.find(name);
    absolute_path = absolute_path.substr(0, pos);
    absolute_path.append(file);
#if APL && __MACH__
    int result = ConvertPath(absolute_path.c_str(), path, 512);
    if (result == 0)
        return std::string(path);
    else
        throw PathSetupError("Critical error - cannot convert Mac-HFS-format path to unix-format path");
#endif
    return absolute_path;
#endif
}

///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////

void PluginPath::setPluginDirectoryName(const std::string& name)
{
    PluginPath::plugin_directory = name;
}

///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////

#if APL && __MACH__
int PluginPath::ConvertPath(const char * inPath, char * outPath, int outPathMaxLen)
{
    CFStringRef inStr = CFStringCreateWithCString(kCFAllocatorDefault, inPath ,kCFStringEncodingMacRoman);
    if (inStr == NULL)
        return -1;
    CFURLRef url = CFURLCreateWithFileSystemPath(kCFAllocatorDefault, inStr, kCFURLHFSPathStyle,0);
    CFStringRef outStr = CFURLCopyFileSystemPath(url, kCFURLPOSIXPathStyle);
    if (!CFStringGetCString(outStr, outPath, outPathMaxLen, kCFURLPOSIXPathStyle))
        return -1;
    CFRelease(outStr);
    CFRelease(url);
    CFRelease(inStr);
    return 0;
}
#endif

