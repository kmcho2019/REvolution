module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out
);
    // Karnaugh map (cd rows, ab columns):
    //       ab
    // cd   00  01  11  10
    // 00 | 1 | 1 | 0 | 1 |
    // 01 | 1 | 0 | 0 | 1 |
    // 11 | 0 | 1 | 1 | 1 |
    // 10 | 1 | 1 | 0 | 0 |

    // Indexing inputs to row and column bits:
    // Row = cd
    // Col = ab

    // Minterms where output=1:
    // cd ab : out
    // 00 00 : 1 -> c=0 d=0 a=0 b=0
    // 00 01 : 1 -> c=0 d=0 a=0 b=1
    // 00 10 : 1 -> c=0 d=0 a=1 b=0
    // 01 00 : 1 -> c=0 d=1 a=0 b=0
    // 01 10 : 1 -> c=0 d=1 a=1 b=0
    // 10 00 : 1 -> c=1 d=0 a=0 b=0
    // 10 01 : 1 -> c=1 d=0 a=0 b=1
    // 11 01 : 1 -> c=1 d=1 a=0 b=1
    // 11 10 : 1 -> c=1 d=1 a=1 b=0
    // 11 11 : 1 -> c=1 d=1 a=1 b=1

    // Writing minterms (a,b,c,d):
    // Minterm 0: ~a & ~b & ~c & ~d
    // Minterm 1: ~a & b & ~c & ~d
    // Minterm 2: a & ~b & ~c & ~d
    // Minterm 4: ~a & ~b & ~c & d
    // Minterm 6: a & ~b & ~c & d
    // Minterm 8: ~a & ~b & c & ~d
    // Minterm 9: ~a & b & c & ~d
    // Minterm 13: ~a & b & c & d
    // Minterm 14: a & ~b & c & d
    // Minterm 15: a & b & c & d

    // Let's simplify by grouping:
    // Group 1: (~c & ~d & ~b) covers minterms 0,4 and part of 2,6? 
    // Actually minterms with ~c & ~d: 0,1,2
    // Group 2: (~c & ~b) covers 0,2,4,6
    // Group 3: (a & b & c & d) only one minterm (15)
    // Group 4: (c & d & b) covers 13,15
    // Group 5: (c & d & a & ~b) covers 14
    // Group 6: (c & ~d & ~a) covers 8,9

    // Alternative is to write directly the sum of minterms:
    assign out = 
        (~a & ~b & ~c & ~d) |  //0
        (~a & b & ~c & ~d)  |  //1
        (a & ~b & ~c & ~d)  |  //2
        (~a & ~b & ~c & d)  |  //4
        (a & ~b & ~c & d)   |  //6
        (~a & ~b & c & ~d)  |  //8
        (~a & b & c & ~d)   |  //9
        (~a & b & c & d)    |  //13
        (a & ~b & c & d)    |  //14
        (a & b & c & d);       //15

endmodule