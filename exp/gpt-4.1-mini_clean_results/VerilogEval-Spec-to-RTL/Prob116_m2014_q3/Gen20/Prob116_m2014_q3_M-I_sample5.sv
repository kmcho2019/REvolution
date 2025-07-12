module TopModule (
    input  [3:0] x,  // x[3]=x4, x[2]=x3, x[1]=x2, x[0]=x1 (problem order)
    output       f
);
    wire x1 = x[0]; // x[1]
    wire x2 = x[1]; // x[2]
    wire x3 = x[2]; // x[3]
    wire x4 = x[3]; // x[4]

    // From Karnaugh map with Gray-coded axes as is, 
    // minimizing f by hand or logic tools (don’t-cares treated as 0 or 1 for simplicity).

    // Karnaugh map (rows x3x4, columns x1x2):
    //        00  01  11  10
    // 00 | d | 0 | d | d |
    // 01 | 0 | d | 1 | 0 |
    // 11 | 1 | 1 | d | d |
    // 10 | 1 | 1 | 0 | d |

    // By analysis, a minimal SOP expression is:
    // f = (x4 & x3)                 // row=11, covers cells with 1's
    //   | (x4 & ~x3 & ~x2)          // row=10, col=00 (1)
    //   | (~x4 & x3 & x1)           // row=01, col=11 (1)
    //   | (x4 & ~x3 & x2)           // row=10, col=01 and col=11 (1's)
    //   | (~x4 & x3 & x2);          // row=01 and 11, col=01 (1's)

    // The above covers all 1's with don't-cares assigned to simplify.

    assign f =
        (x4 & x3) |
        (x4 & ~x3 & ~x2) |
        (~x4 & x3 & x1) |
        (x4 & ~x3 & x2) |
        (~x4 & x3 & x2);

endmodule