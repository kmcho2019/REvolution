module TopModule (
    input  [3:0] x, // x[3] = x4, x[2] = x3, x[1] = x2, x[0] = x1
    output      f
);

    // Map the K-map:
    // Rows (x3 x4): x[2] x[3]
    // Columns (x1 x2): x[0] x[1]
    //
    // K-map cells (row col):
    // r\c 00   01   11   10
    // 00 | d |  0 | d | d | -> row=00 => x[2]=0, x[3]=0
    // 01 | 0 |  d | 1 | 0 | -> row=01 => x[2]=0, x[3]=1
    // 11 | 1 |  1 | d | d | -> row=11 => x[2]=1, x[3]=1
    // 10 | 1 |  1 | 0 | d | -> row=10 => x[2]=1, x[3]=0

    // Translate to minterms (x[3]x[2] x[1]x[0]) or (x4 x3 x2 x1):
    // We'll write as (x[3], x[2], x[1], x[0]) = (x4,x3,x2,x1)

    // 1's:
    // row=01 (x[2]=0,x[3]=1), col=11 (x[1]=1,x[0]=1): (1,0,1,1)
    // row=11 (1,1), col=00 (0,0): (1,1,0,0)
    // row=11 (1,1), col=01 (0,1): (1,1,0,1)
    // row=10 (1,0), col=00 (0,0): (0,1,0,0)
    // row=10 (1,0), col=01 (0,1): (0,1,0,1)
    // Note: Since row bits order is (x[2], x[3]), be careful:
    // Actually, row bits are x[3]x[4], but we swapped to x[2]x[3],
    // so rows correspond to bits [x[3], x[2]] in that order.
    // To avoid confusion, let's define as:
    // row bits: x[3] (MSB), x[2] (LSB)
    // col bits: x[1] (MSB), x[0] (LSB)

    // Hence:
    // row=00: x[3]=0, x[2]=0
    // row=01: x[3]=0, x[2]=1
    // row=11: x[3]=1, x[2]=1
    // row=10: x[3]=1, x[2]=0

    // Given that, rewrite 1's as:
    // row=01 (0,1), col=11 (1,1): x[3]=0, x[2]=1, x[1]=1, x[0]=1
    // row=11 (1,1), col=00 (0,0): x[3]=1, x[2]=1, x[1]=0, x[0]=0
    // row=11 (1,1), col=01 (0,1): x[3]=1, x[2]=1, x[1]=0, x[0]=1
    // row=10 (1,0), col=00 (0,0): x[3]=1, x[2]=0, x[1]=0, x[0]=0
    // row=10 (1,0), col=01 (0,1): x[3]=1, x[2]=0, x[1]=0, x[0]=1

    // Express minterms as product terms for 1's:
    // (1) x[3]=0,x[2]=1,x[1]=1,x[0]=1  => ~x[3] & x[2] & x[1] & x[0]
    // (2) x[3]=1,x[2]=1,x[1]=0,x[0]=0  => x[3] & x[2] & ~x[1] & ~x[0]
    // (3) x[3]=1,x[2]=1,x[1]=0,x[0]=1  => x[3] & x[2] & ~x[1] & x[0]
    // (4) x[3]=1,x[2]=0,x[1]=0,x[0]=0  => x[3] & ~x[2] & ~x[1] & ~x[0]
    // (5) x[3]=1,x[2]=0,x[1]=0,x[0]=1  => x[3] & ~x[2] & ~x[1] & x[0]

    // Group minterms to simplify:
    // Terms (2) and (3): x[3] & x[2] & ~x[1] & (x[0] + ~x[0]) => x[3] & x[2] & ~x[1]
    // Terms (4) and (5): x[3] & ~x[2] & ~x[1] & (x[0] + ~x[0]) => x[3] & ~x[2] & ~x[1]

    // So, function f is:
    // f = (~x[3] & x[2] & x[1] & x[0]) | (x[3] & x[2] & ~x[1]) | (x[3] & ~x[2] & ~x[1])

    // This matches the original core logic but now with correct indexing.

    assign f = (~x[3] & x[2] & x[1] & x[0]) 
             | (x[3] & x[2] & ~x[1]) 
             | (x[3] & ~x[2] & ~x[1]);

endmodule