module LFSR (
    input  wire       clk,
    input  wire       rst,
    output reg  [3:0] out
);

    always @(posedge clk) begin
        if (rst) begin
            out <= 4'b1001; // Non-zero seed to avoid lock-up
        end else begin
            // Calculate feedback as inverted XOR of bits 3 and 2
            wire feedback = ~(out[3] ^ out[2]);
            // Shift right and insert feedback into MSB
            out <= {feedback, out[3:1]};
        end
    end

endmodule