module right_shifter (
    input wire clk,
    input wire d,
    // Optional power optimization (uncomment when needed)
    // input wire enable,  // Clock gating control
    output reg [7:0] q = 0  // Initialization with optional parameter
);

// For power optimization (uncomment when needed)
// wire gated_clk;
// assign gated_clk = clk & enable;

always @(posedge clk /* or posedge gated_clk if using enable */) begin
    q <= {d, q[7:1]};  // Optimal concatenation-based shift
end

endmodule