module TopModule(
    input  d,
    input  ena,
    output reg q
);

// The current implementation is already optimized for the given functionality.
// Further optimizations might require additional context or constraints.
assign q = (ena) ? d : q;

endmodule