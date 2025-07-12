module TopModule (
    input clk,
    input reset,
    output reg [31:0] q
);

// Tap positions: 32, 22, 2, 1 (Galois LFSR configuration)
parameter RESET_VAL = 32'h1;

always @(posedge clk) begin
    if (reset) begin
        q <= RESET_VAL;
    end else begin
        q <= {
            q[0],             // New MSB from old LSB (tap 32)
            q[31:23],         // Untapped upper bits
            q[22] ^ q[0],     // Tap at bit 22
            q[21:3],          // Untapped middle bits
            q[2] ^ q[0],      // Tap at bit 2
            q[1] ^ q[0]       // Tap at bit 1
        };
    end
end

endmodule