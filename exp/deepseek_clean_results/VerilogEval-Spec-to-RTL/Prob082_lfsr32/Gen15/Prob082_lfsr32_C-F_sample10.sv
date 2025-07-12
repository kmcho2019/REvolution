module TopModule (
    input clk,
    input reset,
    output reg [31:0] q
);

// Explicitly name all tap XOR operations
wire tap_22 = q[22] ^ q[0];
wire tap_2 = q[2] ^ q[0];
wire tap_1 = q[1] ^ q[0];

always @(posedge clk) begin
    if (reset) begin
        q <= 32'h1;
    end else begin
        // Clear structure showing each segment of the shift register
        q <= {
            q[0],        // New MSB from LSB (standard LFSR behavior)
            q[31:23],    // Upper bits that shift unchanged
            tap_22,      // First tapped bit (position 22)
            q[21:3],     // Middle bits that shift unchanged
            tap_2,       // Second tapped bit (position 2)
            tap_1        // Third tapped bit (position 1)
        };
    end
end

endmodule