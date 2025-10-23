module TopModule (
    input  wire in1,
    input  wire in2,
    output wire out
);
    // Explicit inversion wire to represent the bubble on in2
    wire not_in2 = ~in2;

    // Output is AND of in1 and inverted in2 (bubble)
    assign out = in1 & not_in2;

endmodule