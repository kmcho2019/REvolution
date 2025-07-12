module TopModule (
    input  wire in1,
    input  wire in2,
    output wire out
);
    // Directly combine in1 and inverted in2 in a single assignment for efficiency
    assign out = in1 & ~in2;
endmodule