module LFSR #(
    parameter [3:0] SEED = 4'b1001  // Default non-zero seed to avoid lock-up
)(
    input  wire       clk,
    input  wire       rst,   // synchronous active-high reset
    output reg  [3:0] out
);

    // Calculate feedback as inverted XOR of MSB and bit 2
    wire feedback = ~(out[3] ^ out[2]);

    always @(posedge clk) begin
        if (rst) begin
            out <= SEED;  // Initialize to parameterized seed on reset
        end else begin
            out <= {out[2:0], feedback}; // Shift left and insert feedback at LSB
        end
    end

endmodule