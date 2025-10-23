module LFSR (
    input  wire       clk,
    input  wire       rst,
    output reg  [3:0] out
);

    // Feedback is inversion of XOR between bits 3 and 2
    wire feedback = ~(out[3] ^ out[2]);

    always @(posedge clk) begin
        if (rst)
            out <= 4'b1001;       // Non-zero seed on reset
        else
            out <= {out[2:0], feedback};  // Shift left, insert feedback at LSB
    end

endmodule