module LFSR #(
    parameter [3:0] INITIAL_SEED = 4'b1001  // Non-zero default seed to avoid lockup
) (
    input  wire       clk,
    input  wire       rst,
    output reg  [3:0] out = INITIAL_SEED   // Initialize to seed for simulation startup
);

    // Feedback taps: XOR of MSB (bit 3) and bit 2, inverted to produce feedback bit
    // Characteristic polynomial: x^4 + x^3 + 1 (corresponds to taps at bit 3 and 2)
    always @(posedge clk) begin
        if (rst)
            out <= INITIAL_SEED;
        else
            // Shift left and insert feedback bit at LSB
            // Using XOR with 1'b1 instead of '~' for inversion (may synthesize better)
            out <= {out[2:0], (out[3] ^ out[2]) ^ 1'b1};
    end

endmodule