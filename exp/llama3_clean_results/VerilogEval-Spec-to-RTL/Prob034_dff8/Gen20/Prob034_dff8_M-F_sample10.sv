// Refactored TopModule using 8 D flip-flops with initialization
module TopModule(
    input clk,
    input [7:0] d,
    output reg [7:0] q = 'b0 // Initialize q to all zeros
);

// Generate 8 DFFs and connect them in parallel
always @(posedge clk) begin
    q <= d; // Non-blocking assignment to avoid race conditions
end

endmodule