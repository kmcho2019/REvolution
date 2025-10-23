module TopModule (
    input clk,
    input reset,
    output reg [31:0] q
);

wire tap_xor = q[0];  // Common XOR term for all taps

always @(posedge clk) begin
    if (reset) begin
        q <= 32'h1;  // More efficient reset (only sets LSB)
    end else begin
        // Main shift operation with taps
        q <= {tap_xor, 
              q[31:22], 
              q[21] ^ tap_xor, 
              q[20:2], 
              q[1] ^ tap_xor, 
              q[0] ^ tap_xor};
    end
end

endmodule