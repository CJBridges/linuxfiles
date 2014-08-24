#include <stdio.h>
#include <sys/types.h>
#include <pwd.h>
#include <stdio.h>
#include <string.h>
#include <unistd.h>
#include <sys/wait.h>
#include <stdlib.h>

#define dprintfs(a) printf("%-20s%s\n", (#a), (a));
#define dprintfi(a) printf("%-20s%d\n", (#a), (a));

int main ( int argc, char **argv )
{
    struct passwd mypwd;
    struct passwd *result = NULL;
    char buf[1024];

    int rc = getpwuid_r( atoi(argv[1]), &mypwd, buf, sizeof( buf ), &result );

    if ( rc == 0 )
    {
        dprintfs( mypwd.pw_name );
        dprintfs( mypwd.pw_passwd );
        dprintfi( mypwd.pw_uid );
        dprintfi( mypwd.pw_gid );
        dprintfs( mypwd.pw_gecos );
        dprintfs( mypwd.pw_dir );
        dprintfs( mypwd.pw_shell );
    }
    else
    {
        dprintfi( rc );
    }

   return 0;
}
