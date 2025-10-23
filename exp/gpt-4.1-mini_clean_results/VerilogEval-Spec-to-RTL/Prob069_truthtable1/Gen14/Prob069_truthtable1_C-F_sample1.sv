module TopModule (
    input  wire x3,
    input  wire x2,
    input  wire x1,
    output wire f
);
    // Intermediate signals for clarity
    wire not_x3;
    wire and_term0, and_term1;

    assign not_x3   = ~x3;
    assign and_term0 = not_x3 & x2;
    assign and_term1 = x3 & x1;
    assign f = and_term0 | and_term1;

endmodule