module TopModule (
    input clk,
    input reset,
    output reg [31:0] q
);

// Tap positions: bits 31 (32-1), 21 (22-1), 1 (2-1), 0 (1-1)
localparam [31:0] TAP_MASK = 32'h8000_0603;

always @(posedge clk) begin
    if (reset) begin
        q <= 32'h1;
    end else begin
        // Compute XOR contribution from LSB to all tap positions
        reg [31:0] xor_contribution = {32{q[0]}} & TAP_MASK;
        // Shift right and apply XOR in parallel
        q <= {q[0], q[31:1]} ^ xor_contribution;
    end
end

endmodule