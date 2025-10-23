module LFSR (
    input  wire       clk,
    input  wire       rst,
    output reg  [3:0] out
);

// Initialize to a non-zero seed on reset to avoid lock-up at zero
// Feedback = inverted XOR of MSB and second MSB, shifted left with feedback at LSB

always @(posedge clk) begin
    if (rst)
        out <= 4'b0001;   // Non-zero seed for maximal sequence length
    else
        out <= {out[2:0], ~(out[3] ^ out[2])};
end

endmodule