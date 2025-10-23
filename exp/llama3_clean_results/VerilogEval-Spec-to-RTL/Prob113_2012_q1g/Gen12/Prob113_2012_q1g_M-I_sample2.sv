module TopModule(
    input [3:0] x,
    output f
);

    assign f = (~x[2] & ~x[3] & (~x[0] & ~x[1] | x[0] & ~x[1])) | // Conditions for x[2]x[3] = 00
               (x[2] & x[3] & (~x[0] & ~x[1] | ~x[0] & x[1] | x[0] & x[1])) | // Conditions for x[2]x[3] = 11
               (x[2] & ~x[3] & (~x[0] & ~x[1] | ~x[0] & x[1] | x[0] & ~x[1])); // Conditions for x[2]x[3] = 10

endmodule