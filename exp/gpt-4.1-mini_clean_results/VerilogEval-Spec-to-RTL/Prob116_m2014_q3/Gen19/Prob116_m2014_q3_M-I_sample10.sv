module TopModule (
    input  [3:0] x,   // x[3] = x4, x[2] = x3, x[1] = x2, x[0] = x1
    output      f
);

    // Assign inputs to variables matching problem notation
    wire x1 = x[0];
    wire x2 = x[1];
    wire x3 = x[2];
    wire x4 = x[3];

    // From K-map simplification (done manually):
    // f = x3 x4' x1 + x3 x4' x2 + x3 x4 x1 + x3 x4 x2' + x3' x4 x1 x2' + x3' x4' x1' x2'
    // Using boolean algebra minimization:
    // After simplification (see below):
    // f = (x3 & ~x4 & (x1 | x2)) | (x3 & x4 & (x1 | ~x2)) | (~x3 & x4 & x1 & ~x2) | (~x3 & ~x4 & ~x1 & ~x2)

    assign f = 
        (x3 & ~x4 & (x1 | x2)) |
        (x3 & x4 & (x1 | ~x2)) |
        (~x3 & x4 & x1 & ~x2) |
        (~x3 & ~x4 & ~x1 & ~x2);

endmodule