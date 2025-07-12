module TopModule(
    input  [3:0] x,
    output f
    );

    wire x0, x1, x2, x3;
    assign x0 = x[0];
    assign x1 = x[1];
    assign x2 = x[2];
    assign x3 = x[3];

    // Logic for x[3] = 0
    wire f_x3_0;
    assign f_x3_0 = ~(x1 & x2) & ~x0;

    // Logic for x[3] = 1
    wire f_x3_1;
    assign f_x3_1 = (x1 & x2) | (~x0 & (x1 | x2));

    // Use a multiplexer to select based on x[3]
    assign f = x3? f_x3_1 : f_x3_0;

endmodule