module TopModule(
    input  in1,
    input  in2,
    output out
);

// The original code is already optimized for area and performance.
// To further reduce power consumption, we consider minimizing switching activity.
// However, given the simplicity of the circuit, significant power reductions might be challenging.
assign out = in1 & (~in2);

endmodule