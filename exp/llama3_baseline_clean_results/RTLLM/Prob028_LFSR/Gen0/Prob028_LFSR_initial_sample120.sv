module LFSR(
    input clk,
    input rst,
    output reg [3:0] out
);

always @ (posedge clk) begin
    if (rst) begin
        out <= 4'b0000;
    end else begin
        // Calculate the feedback signal by XORing the most significant bit (out[3]) and the second most significant bit (out[2])
        // and inverting the result
        reg feedback;
        feedback = ~(out[3] ^ out[2]);
        
        // Shift the bits to the left and insert the new feedback value at the least significant bit (LSB) position
        out <= {out[2:0], feedback};
    end
end

endmodule