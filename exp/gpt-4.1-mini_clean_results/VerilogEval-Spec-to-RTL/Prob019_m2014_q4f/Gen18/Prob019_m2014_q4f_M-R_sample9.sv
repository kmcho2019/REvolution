module TopModule (
    input  wire in1,
    input  wire in2,
    output wire out
);
    wire not_in2;

    // Invert in2 to represent the bubble on the AND gate input
    assign not_in2 = ~in2;

    // AND gate output with in1 and inverted in2
    assign out = in1 & not_in2;
endmodule