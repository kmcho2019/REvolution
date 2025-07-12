module TopModule (
    input  wire in1,
    input  wire in2,
    output wire out
);
    wire not_in2;

    // Explicit inversion of in2 to highlight the bubble at the input of AND
    assign not_in2 = ~in2;

    // AND gate combining in1 and inverted in2
    assign out = in1 & not_in2;

endmodule