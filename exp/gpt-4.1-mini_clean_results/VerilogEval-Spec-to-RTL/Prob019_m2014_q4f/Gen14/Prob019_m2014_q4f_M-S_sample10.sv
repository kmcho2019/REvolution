module TopModule (
    input  wire in1,
    input  wire in2,
    output wire out
);
    // Directly implement the AND gate with an inverted in2 (bubble)
    assign out = in1 & ~in2;
endmodule