module TopModule(
    input [1:0] A,
    input [1:0] B,
    output logic z
);

// The current implementation is straightforward and optimized.
// However, to emphasize the optimization for area and power, we could consider
// if the synthesis tool has specific directives or attributes that can be applied
// to the module or the assign statement to guide the optimization process.

assign z = (A == B);

endmodule