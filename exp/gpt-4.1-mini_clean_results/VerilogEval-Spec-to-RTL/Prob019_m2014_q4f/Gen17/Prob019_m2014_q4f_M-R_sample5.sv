module TopModule (
    input  wire in1,
    input  wire in2,
    output wire out
);
    wire not_in2;

    // Invert in2 to represent the bubble on this input
    assign not_in2 = ~in2;

    // AND gate combining in1 and inverted in2
    assign out = in1 & not_in2;
endmodule