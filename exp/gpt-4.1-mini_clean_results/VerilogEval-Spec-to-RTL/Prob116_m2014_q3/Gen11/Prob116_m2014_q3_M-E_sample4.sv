module TopModule(
    input  [3:0] x,  // x[0]=x1, x[1]=x2, x[2]=x3, x[3]=x4
    output       f
);

    wire x1 = x[0];
    wire x2 = x[1];
    wire x3 = x[2];
    wire x4 = x[3];

    // Karnaugh map (rows = x3x4, cols = x1x2):

    // Let's rewrite the K-map with values (d chosen to minimize f):

    //       x1x2
    // x3x4 00 01 11 10
    // 00 | d | 0 | d | d |
    // 01 | 0 | d | 1 | 0 |
    // 11 | 1 | 1 | d | d |
    // 10 | 1 | 1 | 0 | d |

    // Choosing don't-cares as 0 or 1 to simplify:
    // For minimal SOP, selecting d=0 in upper row to avoid adding unnecessary terms.

    // Minterms where f=1:
    // (x3x4 x1x2)
    // 01 11 = m6
    // 11 00 = m8
    // 11 01 = m9
    // 10 00 = m12
    // 10 01 = m13
    // 11 01 = m9 (already)
    // Also 11 01=1
    // 01 11=1

    // Minterm numbers (4-bit input = x3 x4 x1 x2):
    // m6  = 0 1 1 0 (x3=0,x4=1,x1=1,x2=0) no (wait columns are x1 x2)
    // Actually index is {x3,x4,x1,x2}

    // Minterms for 1:
    // 01 11 = {0,1,1,1} = binary 0111 = decimal 7 (not 6)
    // Check carefully:

    // Let's list all ones:

    // At row=01 (x3=0,x4=1)
    // col=11 (x1=1,x2=1) -> idx= {0,1,1,1} = binary 0111 = decimal 7 -> f=1

    // row=11 (x3=1,x4=1):
    // col=00 -> {1,1,0,0} = 12 -> f=1
    // col=01 -> {1,1,0,1} = 13 -> f=1

    // row=10 (x3=1,x4=0):
    // col=00 -> {1,0,0,0} = 8 -> f=1
    // col=01 -> {1,0,0,1} = 9 -> f=1

    // row=01 (x3=0,x4=1):
    // col=11 -> idx=7 f=1 (as above)
    // row=01 (x3=0,x4=1):
    // col=11 again (no repeat)

    // So f=1 at indices: 7,8,9,12,13

    // Let's try to cover these with prime implicants:

    // Group1: rows 11 and 10, cols 00 and 01
    // (x3=1) and (x1=0) and (x2=don't-care) and (x4=don't-care)
    // Actually:

    // For indices 8(1000),9(1001),12(1100),13(1101):
    // Common: x3=1, x1=0
    // x4 and x2 vary.

    // Group2: index 7 (0111)
    // x3=0,x4=1,x1=1,x2=1

    // So minterms cover: (x3 & ~x1) + (~x3 & x4 & x1 & x2)

    // Further check if any other combination can simplify:

    // There are also minterms at 9 (1001) and 13 (1101) both with x3=1, x1=0, x2=1.

    // So expression can be:

    // f = x3 & ~x1
    //   + ~x3 & x4 & x1 & x2

    // Check if this expression covers all 1's in K-map.

    assign f = (x3 & ~x1) | (~x3 & x4 & x1 & x2);

endmodule