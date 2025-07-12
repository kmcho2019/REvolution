module TopModule (
    input clk,
    input reset,
    output reg [31:0] q
);

// Galois LFSR with taps at positions 32, 22, 2, and 1 (1-based indexing)
parameter RESET_VAL = 32'h1;

// Pre-calculate XOR terms for all taps in parallel
wire tap_xor = q[0];  // Common XOR term (LSB)
wire [31:0] next_q;

assign next_q = {
    tap_xor,                    // New MSB (position 32)
    q[31:23],                   // Untapped bits (positions 31-23)
    q[22] ^ tap_xor,            // Tap at position 22
    q[21:3],                    // Untapped bits (positions 21-3)
    q[2] ^ tap_xor,             // Tap at position 2
    q[1] ^ tap_xor              // Tap at position 1
};

always @(posedge clk) begin
    if (reset) begin
        q <= RESET_VAL;         // Synchronous reset to 32'h1
    end else begin
        q <= next_q;            // Normal LFSR operation
    end
end

endmodule