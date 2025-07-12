module TopModule(
    input clk,
    input d,
    output reg q
);

always @(posedge clk)
    q <= d;

// No changes are made to the original code as it is already optimized.
// The focus should be on the synthesis and technology library to achieve better PPA metrics.

endmodule