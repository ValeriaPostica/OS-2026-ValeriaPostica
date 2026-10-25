#include "kernel/types.h"
#include "user/user.h"

int
main(int argc, char *argv[])
{
    int p2c[2], c2p[2]; // parent-to-child, child-to-parent
    char b;

    if (pipe(p2c) < 0 || pipe(c2p) < 0) {
        printf("pipe failed\n");
        exit(1);
    }

    if(fork() == 0){
        close(p2c[1]); close(c2p[0]); // the ends the child does not use

        // Read 1 byte from parent-to-child pipe
        if (read(p2c[0], &b, 1) != 1) {
            printf("child read failed\n");
            exit(1);
        }
        printf("%d: received ping\n", getpid());

        // Write the byte b into child-to-parent pipe
        if (write(c2p[1], &b, 1) != 1) {
            printf("child write failed\n");
            exit(1);
        }

        close(p2c[0]); close(c2p[1]);
        exit(0);
    }

    close(p2c[0]); close(c2p[1]); // the ends the parent does not use

    // Write 1 byte into parent-to-child pipe to start the game
    if (write(p2c[1], "x", 1) != 1) {
        printf("parent write failed\n");
        exit(1);
    }

    // Read 1 byte from child-to-parent pipe
    if (read(c2p[0], &b, 1) != 1) {
        printf("parent read failed\n");
        exit(1);
    }
    printf("%d: received pong\n", getpid());

    close(p2c[1]); close(c2p[0]);
    wait(0);
    exit(0);
}
