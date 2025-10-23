module TopModule(
    input  [3:0] x,
    output      f
);
    wire x0 = x[0];
    wire x1 = x[1];
    wire x2 = x[2];
    wire x3 = x[3];

    wire term1 = x2 & x3;             // Group1: x2 & x3
    wire term2 = ~x0 & ~x1;           // Group2: ~x0 & ~x1
    wire term3 = x2 & ~x3 & (x0 ^ x1);// Group3: x2 & ~x3 & (x0 XOR x1)

    assign f = term1 | term2 | term3;
endmodule