module TopModule(
    input a,
    input b,
    input c,
    input d,
    output out
);
    // Karnaugh map (cd rows, ab columns):
    // cd\ab 00  01  11  10
    // 00    1   1   0   1
    // 01    1   0   0   1
    // 11    0   1   1   1
    // 10    1   1   0   0

    // List minterms where output=1:
    // cd ab = output
    // 00 00 = 1 -> c=0,d=0,a=0,b=0 -> ~c & ~d & ~a & ~b
    // 00 01 = 1 -> c=0,d=0,a=0,b=1 -> ~c & ~d & ~a & b
    // 00 10 = 1 -> c=0,d=0,a=1,b=0 -> ~c & ~d & a & ~b
    // 01 00 = 1 -> c=0,d=1,a=0,b=0 -> ~c & d & ~a & ~b
    // 01 10 = 1 -> c=0,d=1,a=1,b=0 -> ~c & d & a & ~b
    // 10 00 = 1 -> c=1,d=0,a=0,b=0 -> c & ~d & ~a & ~b
    // 10 01 = 1 -> c=1,d=0,a=0,b=1 -> c & ~d & ~a & b
    // 11 01 = 1 -> c=1,d=1,a=0,b=1 -> c & d & ~a & b
    // 11 10 = 1 -> c=1,d=1,a=1,b=0 -> c & d & a & ~b
    // 11 11 = 1 -> c=1,d=1,a=1,b=1 -> c & d & a & b

    // Implement sum of minterms:
    assign out = 
        (~c & ~d & ~a & ~b) |
        (~c & ~d & ~a &  b) |
        (~c & ~d &  a & ~b) |
        (~c &  d & ~a & ~b) |
        (~c &  d &  a & ~b) |
        ( c & ~d & ~a & ~b) |
        ( c & ~d & ~a &  b) |
        ( c &  d & ~a &  b) |
        ( c &  d &  a & ~b) |
        ( c &  d &  a &  b);

endmodule