module TopModule (
    input clk,
    input reset,
    output reg [31:0] q
);

// Tap positions: 32, 22, 2, 1 (Galois LFSR configuration)
// Power optimization: XOR only when q[0] is 1
wire tap_enable = q[0];
wire [31:0] next_state;

// Shared XOR structure for taps
wire tap_22 = tap_enable ? q[22] ^ q[0] : q[22];
wire tap_2 = tap_enable ? q[2] ^ q[0] : q[2];
wire tap_1 = tap_enable ? q[1] ^ q[0] : q[1];

assign next_state = {
    q[0],        // New MSB from old LSB (tap 32)
    q[31:23],    // Untapped upper bits
    tap_22,      // Optimized tap at bit 22
    q[21:3],     // Untapped middle bits
    tap_2,       // Optimized tap at bit 2
    tap_1        // Optimized tap at bit 1
};

always @(posedge clk) begin
    if (reset) begin
        q <= 32'h1;  // Hardcoded reset value for area optimization
    end else begin
        q <= next_state;
    end
end

endmodule