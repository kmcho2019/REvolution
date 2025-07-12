module TopModule(
    input [3:0] x,
    output f
);

    wire x00, x01, x10, x11;  // Conditions for x[2] and x[3]

    assign x00 = ~x[2] & ~x[3];
    assign x11 = x[2] & x[3];
    assign x10 = x[2] & ~x[3];

    wire f00, f11, f10;  // Conditions for f

    assign f00 = (~x[0] & ~x[1]) | (x[0] & ~x[1]);
    assign f11 = (~x[0] & ~x[1]) | (~x[0] & x[1]) | (x[0] & x[1]);
    assign f10 = (~x[0] & ~x[1]) | (~x[0] & x[1]) | (x[0] & ~x[1]);

    assign f = (x00 & f00) | (x11 & f11) | (x10 & f10);

endmodule