module LFSR(
    input clk,
    input rst,
    output reg [3:0] out
);

always @ (posedge clk) begin
    if (rst) begin
        // Reset the register to zero when rst is high
        out <= 4'b0000;
    end else begin
        // Calculate the feedback signal by XORing the most significant bit and the second most significant bit, and inverting the result
        reg feedback;
        feedback = ~(out[3] ^ out[2]);
        
        // Shift the bits in the register left and insert the new feedback value at the LSB
        out <= {out[2:0], feedback};
    end
end

endmodule