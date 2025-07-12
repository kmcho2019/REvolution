module TopModule (
    input  wire in1,
    input  wire in2,
    output wire out
);
    // Invert in2 to represent the bubble on this input
    wire inv_in2;
    assign inv_in2 = ~in2;

    // AND gate combining in1 with inverted in2
    assign out = in1 & inv_in2;

endmodule