module LFSR #(
    parameter [3:0] SEED = 4'b0001  // Non-zero initial seed to avoid lock-up at zero
) (
    input  wire       clk,
    input  wire       rst,
    output reg [3:0]  out
);

    always @(posedge clk) begin
        if (rst) begin
            out <= SEED;
        end else begin
            // Compute feedback locally and insert at LSB
            // Feedback = inverted XOR of out[3] and out[2]
            // So feedback = ~(out[3] ^ out[2])
            // Shift left by 1 bit and insert feedback at bit 0
            out <= {out[2:0], ~(out[3] ^ out[2])};
        end
    end

endmodule