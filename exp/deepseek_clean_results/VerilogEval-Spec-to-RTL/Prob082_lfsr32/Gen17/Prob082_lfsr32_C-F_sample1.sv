module TopModule (
    input clk,
    input reset,
    output reg [31:0] q
);

always @(posedge clk) begin
    if (reset) begin
        q <= 32'h1;  // Synchronous reset to initial seed value
    end else begin
        // 32-bit Galois LFSR with taps at positions 32, 22, 2, and 1
        // Structure: [new MSB] [untapped upper bits] [tapped bit] [untapped middle bits] [tapped bits]
        q <= {
            q[0],                     // Position 32: MSB gets q[0] (tap)
            q[31:23],                 // Positions 31-23: simple shift (no taps)
            q[22] ^ q[0],            // Position 22: tapped (XOR with q[0])
            q[21:3],                  // Positions 21-3: simple shift (no taps)
            q[2] ^ q[0],              // Position 2: tapped (XOR with q[0])
            q[1] ^ q[0]               // Position 1: tapped (XOR with q[0])
        };
    end
end

endmodule