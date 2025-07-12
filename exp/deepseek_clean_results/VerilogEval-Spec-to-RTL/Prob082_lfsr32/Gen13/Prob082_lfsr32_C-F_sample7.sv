module TopModule (
    input clk,
    input reset,
    output reg [31:0] q
);

always @(posedge clk) begin
    if (reset) begin
        q <= 32'h1;  // Synchronous reset to initial value
    end else begin
        // Galois LFSR with taps at positions 32, 22, 2, and 1
        // MSB (position 32) gets q[0], other taps XOR with q[0]
        q <= {
            q[0],                     // Position 32 (tap)
            q[31:23],                 // Untapped positions 31-23
            q[22] ^ q[0],             // Position 22 (tap)
            q[21:3],                  // Untapped positions 21-3
            q[2] ^ q[0],              // Position 2 (tap)
            q[1] ^ q[0]               // Position 1 (tap)
        };
    end
end

endmodule