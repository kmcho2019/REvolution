module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);
    // From the K-map:

    // K-map layout:
    //          ab
    //  cd   00  01  11  10
    //  00 | 1 | 1 | 0 | 1 |
    //  01 | 1 | 0 | 0 | 1 |
    //  11 | 0 | 1 | 1 | 1 |
    //  10 | 1 | 1 | 0 | 0 |

    // After manual simplification, a minimal sum-of-products:
    // out = (~d & ~a)         // group covering top-left and bottom-left corners (cd=00 and 10, ab=00 and 01)
    //      | (~c & ~b)        // group covering first two rows of second column
    //      | (c & d & (a | b)); // group covering bottom-right ones

    wire term1 = ~d & ~a;
    wire term2 = ~c & ~b;
    wire term3 = c & d & (a | b);

    assign out = term1 | term2 | term3;

endmodule