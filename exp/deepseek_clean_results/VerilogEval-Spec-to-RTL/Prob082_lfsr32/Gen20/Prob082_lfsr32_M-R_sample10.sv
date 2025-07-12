module TopModule (
    input clk,
    input reset,
    output reg [31:0] q
);

wire tap_xor = q[0];  // Precompute XOR term (just q[0] since we XOR with it)

always @(posedge clk) begin
    if (reset) begin
        q <= 32'h1;  // Simple reset to 1 (sets q[0]=1, others=0)
    end else begin
        // Handle all bits in parallel
        q <= {tap_xor,                      // Bit 31 (position 32)
              q[31:22],                      // Bits 30-21
              q[21] ^ tap_xor,               // Bit 21 (position 22)
              q[20:2],                       // Bits 20-2
              q[1] ^ tap_xor,               // Bit 1 (position 2)
              q[0] ^ tap_xor};              // Bit 0 (position 1)
    end
end

endmodule