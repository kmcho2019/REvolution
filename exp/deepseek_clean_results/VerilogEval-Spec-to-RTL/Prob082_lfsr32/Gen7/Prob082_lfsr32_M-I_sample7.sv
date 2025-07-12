module TopModule (
    input clk,
    input reset,
    output reg [31:0] q
);

// Shared XOR for adjacent taps (bits 2 and 1)
wire tap_xor = q[0] & (|q[2:1]);

always @(posedge clk) begin
    if (reset) begin
        q <= 32'h1;  // Power-efficient reset (only sets bit 0)
    end else begin
        // Balanced implementation with optimized tap positions
        q <= {q[0], 
              q[31:23], 
              q[22] ^ q[0], 
              q[21:3], 
              q[2] ^ tap_xor, 
              q[1] ^ tap_xor};
    end
end

endmodule