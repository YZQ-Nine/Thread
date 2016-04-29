//
//  ViewController.m
//  多线程
//
//  Created by YZQ_Nine on 16/4/12.
//  Copyright © 2016年 YZQ_Nine. All rights reserved.
//

#import "ViewController.h"
#import <pthread.h>
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}
#pragma mark - pthread

void * run(void *param){
    
    for (NSInteger i = 0; i < 10000; i++) {
        NSLog(@"---------ptrhreadClick-----%zd---%@",i,[NSThread currentThread]);
    }
    return NULL;
}

- (IBAction)pthreadClick:(UIButton *)sender {
    pthread_t thread;
    pthread_create(&thread, NULL, run, NULL);
}

#pragma mark - NSThread

- (IBAction)NSThread1Click:(id)sender {

    [self createThread1];
}
- (IBAction)NSThread2Click:(id)sender {

    [self createThrerad2];
}
- (IBAction)NSThread3Click:(id)sender {

    [self createThrerad3];
}
//创建方法一
//法一比法二的好处：可以拿到当前线程，设置一些属性
- (void)createThread1{
    //创建线程
    NSThread *thread = [[NSThread alloc] initWithTarget:self selector:@selector(run:) object:@"123"];
    //给线程起名
    //thread.name = @"my-thread";
    //启动线程
    [thread start];
}
//创建方法二
- (void)createThrerad2{

    [NSThread detachNewThreadSelector:@selector(run:) toTarget:self withObject:@"法二"];
}
//创建方法三
- (void)createThrerad3{
    
    [self performSelectorInBackground:@selector(run:) withObject:nil];
}

- (void)run:(NSString *)param{
    
    for (NSInteger i = 0; i < 50000; i++) {
        NSLog(@"---------run-----%@---%@",param,[NSThread currentThread]);
    }
}

#pragma mark - GCD

/*
 * 异步函数 + 并发队列 ：可同时开启多条线程，开发中常用
 */
- (IBAction)AsyncConcurrent:(id)sender {
    
    /*
     1、
     利用系统方式创建并行队列
     参数一：队列优先级
     参数二：写0就行
     */
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    /*
     自定义方式创建一个并发队列
     label：相当于队列的名字（C语言字符串）
     attr:选择是并发（DISPATCH_QUEUE_CONCURRENT）还是串行（DISPATCH_QUEUE_SERIAL）
     */
    //    dispatch_queue_t queue = dispatch_queue_create("new", DISPATCH_QUEUE_CONCURRENT);
    
    //2、将任务加入队列(async：异步)
    dispatch_async(queue, ^{
        
        for (int i = 0; i < 10; i++) {
            NSLog(@"1---%@",[NSThread currentThread]);
        }
        
    });
    
    dispatch_async(queue, ^{
        
        for (int i = 0; i < 10; i++) {
            NSLog(@"2---%@",[NSThread currentThread]);
        }
        
    });
    
    dispatch_async(queue, ^{
        
        for (int i = 0; i < 10; i++) {
            NSLog(@"3---%@",[NSThread currentThread]);
        }
        
    });
}

/*
 * 同步函数 + 并发队列：不会开辟子线程
 */
- (IBAction)SyncConcurrent:(id)sender {
    //获取全局的并发队列
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    //将任务加入队列
    dispatch_sync(queue, ^{
        
        for (int i = 0; i < 10; i++) {
            NSLog(@"1---%@",[NSThread currentThread]);
        }
        
    });
    
    dispatch_sync(queue, ^{
        
        for (int i = 0; i < 10; i++) {
            NSLog(@"2---%@",[NSThread currentThread]);
        }
    });
}

/*
 * 异步函数 + 串行队列：会开启新的线程，但是任务是串行的，执行完一个任务在执行下一个任务
 */
- (IBAction)AsyncSerial:(id)sender {

    //1、创建串行队列
    dispatch_queue_t queue = dispatch_queue_create("serical", DISPATCH_QUEUE_SERIAL);
//    dispatch_queue_t queue = dispatch_queue_create("serical", NULL);//以上两个一样
    //2、将任务加入队列
    dispatch_async(queue, ^{
        
        for (int i = 0; i < 10; i++) {
            NSLog(@"1---%@",[NSThread currentThread]);
        }
    });
    
    dispatch_async(queue, ^{
        
        for (int i = 0; i < 10; i++) {
            NSLog(@"2---%@",[NSThread currentThread]);
        }
    });
}

/*
 * 同步函数 + 并发队列：不会开启新的线程
 */
- (IBAction)SyncSerial:(id)sender {

    //获取全局的并发队列
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    //2、将任务加入队列
    dispatch_sync(queue, ^{
        
        for (int i = 0; i < 10; i++) {
            NSLog(@"1---%@",[NSThread currentThread]);
        }
    });
    
    dispatch_sync(queue, ^{
        
        for (int i = 0; i < 10; i++) {
            NSLog(@"2---%@",[NSThread currentThread]);
        }
    });
}

/*
 * 主队列：任务只在主线程中执行
 * 异步函数 + 主队列：不会开辟子线程，
 */
- (IBAction)AsyncMain:(id)sender {

    //获取主队列
    dispatch_queue_t queue = dispatch_get_main_queue();
    //2、将任务加入队列
    dispatch_async(queue, ^{
        
        for (int i = 0; i < 10; i++) {
            NSLog(@"1---%@",[NSThread currentThread]);
        }
    });
    
    dispatch_async(queue, ^{
        
        for (int i = 0; i < 10; i++) {
            NSLog(@"2---%@",[NSThread currentThread]);
        }
    });

}

/*
 * 同步函数 + 主队列： 这个会发生阻塞，不建议这样写
 */
- (IBAction)SyncMain:(id)sender {

    //获取主队列
    dispatch_queue_t queue = dispatch_get_main_queue();
    //2、将任务加入队列
    dispatch_sync(queue, ^{
        
        for (int i = 0; i < 10; i++) {
            NSLog(@"1---%@",[NSThread currentThread]);
        }
    });
    
    dispatch_sync(queue, ^{
        
        for (int i = 0; i < 10; i++) {
            NSLog(@"2---%@",[NSThread currentThread]);
        }
    });
    
    
    
}

#pragma mark - NSOperationQueue
- (IBAction)NSOperationQueue:(id)sender {

    [self operationQueue1];
}

- (void)operationQueue1
{
    // 创建队列
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    //设置最大并发数
    queue.maxConcurrentOperationCount = 3;
    //queue.maxConcurrentOperationCount = 1//这样就成串行的了
    
    // 创建操作（任务）
    
    //方法三 创建 OperationWithBlock
    [queue addOperationWithBlock:^{
        NSLog(@"download6 --- %@", [NSThread currentThread]);
    }];
    
    [queue addOperationWithBlock:^{
        NSLog(@"download7 --- %@", [NSThread currentThread]);
    }];
    
    // 方法一： 创建NSInvocationOperation
    NSInvocationOperation *op1 = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(download1) object:nil];
    NSInvocationOperation *op2 = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(download2) object:nil];
    
    //方法二： 创建NSBlockOperation
    NSBlockOperation *op3 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"download3 --- %@", [NSThread currentThread]);
    }];
    
    [op3 addExecutionBlock:^{
        NSLog(@"download4 --- %@", [NSThread currentThread]);
    }];
    [op3 addExecutionBlock:^{
        NSLog(@"download5 --- %@", [NSThread currentThread]);
    }];
    
    // 添加任务到队列中
    [queue addOperation:op1]; // [op1 start]
    [queue addOperation:op2]; // [op2 start]
    [queue addOperation:op3]; // [op3 start]
    
}

- (void)download1
{
    NSLog(@"download1 --- %@", [NSThread currentThread]);
}

- (void)download2
{
    NSLog(@"download2 --- %@", [NSThread currentThread]);
}

















@end
