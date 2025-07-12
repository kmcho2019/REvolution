module LFSR (
    input  wire       clk,
    input  wire       rst,
    output reg  [3:0] out
);

    // Feedback is inversion of XOR of bits 3 and 2 (MSB and next MSB)
    wire feedback = ~(out[3] ^ out[2]);

    always @(posedge clk) begin
        if (rst)
            out <= 4'b0000;      // Initialize to zero as problem states (may cause lock-up)
        else
            out <= {out[2:0], feedback}; // Shift left, insert feedback at LSB
    end

endmodule