#ifndef __CLSDEFS_H
#define __CLSDEFS_H

//
// This file contains proprietary information of Borland International.
// Copying or reproduction without prior written approval is prohibited.
//
// Copyright (c) 1990
// Borland International
// 1800 Scotts Valley Dr.
// Scotts Valley, CA 95066
// (408) 438-8400
//

// Contents ----------------------------------------------------------------
//
//      ERROR_CLASS_HASH_VALUE
//
//      __EEXPAND
//      __ENOMEM
//      __ENOTSORT
//      __ENOTASSOC
//
// Description
//
//      Definitions for the C++ class library.
//
// End ---------------------------------------------------------------------

// Interface Dependencies ---------------------------------------------------

#ifndef __CLSTYPES_H
#include "clstypes.h"
#endif

// End Interface Dependencies ------------------------------------------------

// LiteralSection ----------------------------------------------------------
//
//      hash values
//
// Description
//
//      For some classes it doesn't make sense to use any particular hash
//      function on an object of that class to get a hash value, so we
//      provide some default ones instead.  These are returned by member
//      functions hashValue.
//
// End ---------------------------------------------------------------------

#define ERROR_CLASS_HASH_VALUE                      (hashValueType)0
                                                                                                                                    
// End LiteralSection hash values //


// LiteralSection ----------------------------------------------------------
//
//      error codes
//
// Description
//
//      Defines run time error codes generated by the class libraries.
//
// End ---------------------------------------------------------------------

#define __EEXPAND                               2
                                                                                                                                    
#define __ENOMEM                                3
                                                                                                                                    
#define __ENOTSORT                              4
                                                                                                                                    
#define __ENOTASSOC                             5
                                                                                                                                    
// End LiteralSection error codes //

#endif // ifndef __CLSDEFS_H //


