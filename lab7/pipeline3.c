#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/wait.h>

/* does the same as the shell command: ls /usr/bin | grep x | wc -l */
int main(void)
{
    int p1[2], p2[2];

    if (pipe(p1) < 0) { perror("pipe 1"); return 1; }
    if (pipe(p2) < 0) { perror("pipe 2"); return 1; }

    /* Child 1: ls /usr/bin */
    if (fork() == 0) {
        close(1); dup(p1[1]);
        close(p1[0]); close(p1[1]);
        close(p2[0]); close(p2[1]);
        execlp("ls", "ls", "/usr/bin", (char *) NULL);
        perror("exec ls"); exit(127);
    }

    /* Child 2: grep x */
    if (fork() == 0) {
        close(0); dup(p1[0]);
        close(1); dup(p2[1]);
        close(p1[0]); close(p1[1]);
        close(p2[0]); close(p2[1]);
        execlp("grep", "grep", "x", (char *) NULL);
        perror("exec grep"); exit(127);
    }

    /* Child 3: wc -l */
    if (fork() == 0) {
        close(0); dup(p2[0]);
        close(p1[0]); close(p1[1]);
        close(p2[0]); close(p2[1]);
        execlp("wc", "wc", "-l", (char *) NULL);
        perror("exec wc"); exit(127);
    }

    /* Parent closes all pipe ends */
    close(p1[0]); close(p1[1]);
    close(p2[0]); close(p2[1]);

    /* Parent waits for all three children */
    wait(NULL); wait(NULL); wait(NULL);

    return 0;
}
