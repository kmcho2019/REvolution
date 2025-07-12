module TopModule(
    input clk,
    input a,
    output reg q
);

// Using a non-blocking assignment and maintaining the same functionality
always @(posedge clk)
    q <= ~a;

// Alternatively, considering clock gating (for illustrative purposes, though the provided example does not directly benefit from it)
// wire gated_clk = (a != 1'b0) ? clk : 1'b0; // Example condition, actual logic may vary
// always @(posedge gated_clk)
//     q <= ~a;

endmodule