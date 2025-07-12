module TopModule(
    input [3:0] x,
    output f
);

    // Introduction of intermediate signals for x[0] and x[1]
    wire x0_x1_00, x0_x1_10;

    assign x0_x1_00 = ~x[0] & ~x[1];
    assign x0_x1_10 = x[0] & ~x[1];

    // Direct mapping of conditions from the Karnaugh map
    assign f = (~x[2] & ~x[3] & (x0_x1_00 | x0_x1_10)) | 
               (x[2] & x[3] & (x0_x1_00 | ~x[0] & x[1] | x[0] & x[1])) | 
               (x[2] & ~x[3] & (x0_x1_00 | ~x[0] & x[1] | x0_x1_10));

endmodule