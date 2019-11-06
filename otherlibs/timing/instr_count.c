#include <stdlib.h>
#include <stdio.h>
#include <unistd.h>
#include <string.h>
#include <sys/ioctl.h>
#include <linux/perf_event.h>
#include <asm/unistd.h>
 
#include "instr_count.h"

int fd;

static void setupPerfEvent(struct perf_event_attr *pe)
{
    memset(pe, 0, sizeof(struct perf_event_attr));
    pe->type = PERF_TYPE_HARDWARE;
    pe->size = sizeof(struct perf_event_attr);
    pe->config = PERF_COUNT_HW_INSTRUCTIONS;
    pe->disabled = 1;
    pe->exclude_kernel = 1;
    pe->exclude_hv = 1;
}

static void startCounting(int fd)
{
    ioctl(fd, PERF_EVENT_IOC_RESET, 0);
    ioctl(fd, PERF_EVENT_IOC_ENABLE, 0);
}

static long long stopCounting(int fd)
{
    long long count;
    ioctl(fd, PERF_EVENT_IOC_DISABLE, 0);
    read(fd, &count, sizeof(long long));
    return count;
}

static long perf_event_open(
    struct perf_event_attr *hw_event,
    pid_t pid,
    int cpu,
    int group_fd,
    unsigned long flags
) {
    int ret;

    ret = syscall(
        __NR_perf_event_open,
        hw_event,
        pid,
        cpu,
        group_fd,
        flags
    );

    return ret;
}

static int perf_open_check(struct perf_event_attr *pe)
{
    int fd = perf_event_open(pe, 0, -1, -1, 0);
    if (fd == -1) {
       fprintf(stderr, "Error opening leader %llx\n", pe->config);
       exit(EXIT_FAILURE);
    }
    return fd;
}

void start_instr_count() {
    struct perf_event_attr pe;
    setupPerfEvent(&pe);
    fd = perf_open_check(&pe);
    startCounting(fd);
}

void stop_instr_count() {
    printf("Used %lld instruction\n", stopCounting(fd));
    close(fd);
}
