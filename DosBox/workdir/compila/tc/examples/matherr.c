/*------------------------------------------------------------------------
 * filename - matherr.c
 *
 * function(s)
 *        matherr - user-modifiable math error handler
 *-----------------------------------------------------------------------*/

/*[]---------------------------------------------------[]*/
/*|							|*/
/*|	Turbo C Run Time Library - Version 3.0		|*/
/*|							|*/
/*|							|*/
/*|	Copyright (c) 1987,1990 by Borland International    |*/
/*|	All Rights Reserved.				|*/
/*|							|*/
/*[]---------------------------------------------------[]*/


#include <math.h>

#ifdef	UNIX_matherr
#include <stdio.h>
#include <process.h>

char *whyS [] =
{
    "argument domain error",
    "argument singularity ",
    "overflow range error ",
    "underflow range error",
    "total loss of significance",
    "partial loss of significance"
};

/*------------------------------------------------------------------------*

Name		matherr - user-modifiable math error handler

Usage		#include <math.h>
		int matherr(struct exception *e);

Prototype in	math.h

Description	When  exceptions are  detected in  the math  library then a
		call is made  to  _matherr()  with all the available
		information.

		That function does very little, except to map the exception
		"why"  into either  ERANGE or  EDOMAIN in  errno. Its  main
		purpose is  to act as  a focal point  for changes in  error
		handling.

		For example,  if you were  writing a spreadsheet  you might
		replace  this function with one which pops up an error
		window explaining something like:

			"log (-2.0) caused domain error, in cell J7"

		and then longjmp() to a  reset state in the spreadsheet and
		await the next command from the user.

		The default version  of Turbo C's matherr routine masks
		underflow and precision errors; others errors are considered
		fatal.  It serves as a hook that you can replace when
		writing your own math error handling routine.

		The rationale for masking underflow and precision errors
		is that these are not errors according to the ANSI C spec.
		Consequently, you will get
			exp(-1000) = 0
			sin(1e100) = NAN
		without any error or warning, even though there is a total
		loss of precision in both cases.  You can trap these errors
		by modifying matherr.

		The possible errors are
			DOMAIN, SING, OVERFLOW, UNDERFLOW, TLOSS, PLOSS
		and listed in <math.h>.  As explained above, UNDERFLOW and
		TLOSS are masked by the default matherr.  PLOSS is not
		supported by TC and is not generated by any library functions.
		The remaining errors, DOMAIN, SING, and OVERFLOW, are fatal
		with the default matherr.

		You  can  modify  matherr  to  be  a  custom error handling
		routine (such as one that catches and resolves certain type
		of  errors); the  modified matherr  should return  0 if  it
		failed to resolve  the error, or non-zero if  the error was
		resolved. When matherr returns non-zero, no  error message
		is printed, and errno is not changed.

		The  important thing  is  that  we  don't  know what error
		handling you want, but you are assured that all errors will
		arrive at  matherr() with all  the information you  need to
		design a custom format.

		We  do not  ship as  standard the  function named matherr()
		which may be  familiar to UNIX users, since  the ANSI x3j11
		draft specifies  an incompatible style. This  version is as
		close as we could get  without breaking the ANSI rules. You
		can, however, convert this version to the UNIX style if you
		prefer. The necessary code is included but switched off.

Return value	The default return  value for matherr is simply  0.
		matherr can also modify  e->retval, which propagates through
		_matherr back to the original caller.

		When matherr returns 0, (indicating that it was not able to
		resolve the error) _matherr sets  errno and prints an error
		message.

		When matherr returns non-zero, (indicating that it was able
		to resolve the error) errno is not set and no messages are
		printed.

*-------------------------------------------------------------------------*/
int matherr (struct exception *e)
{
    fprintf (stderr,
	"%s (%8g,%8g): %s\n", e->name, e->arg1, e->arg2, whyS [e->type - 1]);

    exit (1);
}
#else

int matherr(struct exception *e)
{
	if (e->type == UNDERFLOW)
	{
		/* flush underflow to 0 */
		e->retval = 0;
		return 1;
	}
	if (e->type == TLOSS)
	{
		/* total loss of precision, but ignore the problem */
		return 1;
	}
	/* all other errors are fatal */
	return 0;
}


#endif
