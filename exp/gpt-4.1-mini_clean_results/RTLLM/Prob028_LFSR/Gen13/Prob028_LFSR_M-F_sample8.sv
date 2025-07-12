module LFSR (
    input  wire       clk,
    input  wire       rst,
    output reg  [3:0] out
);

    // Feedback is inverted XOR of bits 3 and 2
    wire feedback = ~(out[3] ^ out[2]);

    always @(posedge clk) begin
        if (rst) begin
            out <= 4'b1001; // Non-zero seed on reset
        end else begin
            // Shift left and insert feedback at LSB
            out <= {out[2:0], feedback};
        end
    end

endmodule