module TopModule (
    input  wire in1,
    input  wire in2,
    output wire out
);
    // Directly implement AND gate with inversion on in2 (bubble)
    assign out = in1 & ~in2;
endmodule