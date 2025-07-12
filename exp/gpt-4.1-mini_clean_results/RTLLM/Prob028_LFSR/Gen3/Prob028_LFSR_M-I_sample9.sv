module LFSR (
    input  wire       clk,
    input  wire       rst,      // Active high synchronous reset
    output reg  [3:0] out
);

    // Feedback is inversion of XOR of bits 3 and 2
    wire feedback = ~(out[3] ^ out[2]);

    always @(posedge clk) begin
        if (rst) begin
            out <= 4'b0000;  // Initialize to zero on reset
        end else begin
            out <= {out[2:0], feedback};  // Shift left and insert feedback at LSB
        end
    end

endmodule