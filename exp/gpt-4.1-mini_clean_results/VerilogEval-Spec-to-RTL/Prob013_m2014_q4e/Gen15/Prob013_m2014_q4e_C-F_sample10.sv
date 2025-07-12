module TopModule (
    input  wire in1,
    input  wire in2,
    output wire out
);
    // Use the built-in nor primitive directly for best PPA and minimal hierarchy
    nor (out, in1, in2);
endmodule