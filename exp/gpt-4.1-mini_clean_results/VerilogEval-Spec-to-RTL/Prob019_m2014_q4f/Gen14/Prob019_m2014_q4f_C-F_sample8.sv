module TopModule (
    input  wire in1,
    input  wire in2,
    output wire out
);
    // Explicitly declare inverted in2 to reflect the bubble on input in2
    wire not_in2 = ~in2;

    // Combine in1 and inverted in2 with AND gate
    assign out = in1 & not_in2;
endmodule