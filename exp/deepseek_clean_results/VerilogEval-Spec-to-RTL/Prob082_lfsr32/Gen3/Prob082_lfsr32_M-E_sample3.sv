module TopModule (
    input clk,
    input reset,
    output reg [31:0] q
);

// Tap positions: 32, 22, 2, 1 (1-based)
localparam [31:0] TAP_MASK = {1'b1, 9'b0, 1'b1, 9'b0, 1'b1, 9'b0, 1'b1};

always @(posedge clk) begin
    if (reset) begin
        q <= 32'h1;  // Initialize to 1 (bit 1 set in 1-based)
    end
    else begin
        // Calculate feedback (always q[0] in 0-based, which is bit 1 in 1-based)
        // Apply feedback to tap positions and shift right
        q <= {1'b0, q[31:1]} ^ (TAP_MASK & {32{q[0]}});
    end
end

endmodule