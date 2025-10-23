module TopModule(
    input  [3:0] x,
    output      f
);
    // Map input bits as per Karnaugh map:
    // r1 = x[2], r0 = x[3], c1 = x[0], c0 = x[1]
    wire r1 = x[2];
    wire r0 = x[3];
    wire c1 = x[0];
    wire c0 = x[1];

    assign f = (~r1 & r0 & c1)     // ~x[2] & x[3] & x[0]
             | (r1 & ~r0)          // x[2] & ~x[3]
             | (r1 & r0 & ~c0)     // x[2] & x[3] & ~x[1]
             | (~r1 & ~r0 & ~c0 & c1); // ~x[2] & ~x[3] & ~x[1] & x[0]

endmodule