module LFSR(
    input clk,
    input rst,
    output reg [3:0] out
);

always @ (posedge clk or posedge rst) begin
    if (rst) begin
        out <= 4'd0; // Initialize the register to zero when reset is high
    end else begin
        // Calculate the feedback by XORing the most significant bit and the second most significant bit
        reg fb;
        assign fb = ~(out[3] ^ out[2]);
        
        // Shift the bits to the left and insert the new feedback value at the LSB
        out <= {out[2:0], fb};
    end
end

endmodule