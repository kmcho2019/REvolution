module LFSR(
    input clk,
    input rst,
    output reg [3:0] out
);

always @(posedge clk) begin
    if (rst) begin
        // Reset the register to zero when reset is high
        out <= 4'b0000;
    end else begin
        // Calculate the feedback by XORing the MSB and the second MSB, then inverting the result
        wire feedback = ~(out[3] ^ out[2]);
        
        // Shift the bits in the register to the left and insert the feedback at the LSB
        out <= {out[2:0], feedback};
    end
end

endmodule