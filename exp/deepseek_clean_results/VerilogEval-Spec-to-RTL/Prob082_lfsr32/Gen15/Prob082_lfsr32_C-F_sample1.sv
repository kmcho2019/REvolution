module TopModule (
    input clk,
    input reset,
    output reg [31:0] q
);

always @(posedge clk) begin
    if (reset) begin
        q <= 32'h1;  // Synchronous reset to initial value
    end else begin
        // Galois LFSR with taps at positions:
        // 32 (MSB), 22, 2, and 1 (LSB)
        // Tapped positions XOR with q[0]
        q <= {q[0],                    // Position 32 (tap)
              q[31:23],                // Positions 31-23 (untapped)
              q[22] ^ q[0],            // Position 22 (tap)
              q[21:3],                 // Positions 21-3 (untapped)
              q[2] ^ q[0],            // Position 2 (tap)
              q[1] ^ q[0]};            // Position 1 (tap)
    end
end

endmodule