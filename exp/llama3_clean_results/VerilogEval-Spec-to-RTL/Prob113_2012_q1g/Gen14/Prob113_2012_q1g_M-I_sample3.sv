module TopModule(
    input [3:0] x,
    output f
);

    assign f = (~x[2] & ~x[3] & (~x[0] | ~x[1])) | // Simplified conditions for x[2]x[3] = 00
               (x[2] & x[3]) | // Simplified condition for x[2]x[3] = 11, considering all x[0]x[1] except 10
               (x[2] & ~x[3] & (~x[0] | ~x[1])); // Simplified conditions for x[2]x[3] = 10

endmodule