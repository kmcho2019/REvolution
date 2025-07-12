module LFSR(
    input clk,
    input rst,
    output reg [3:0] out
);

always @ (posedge clk) begin
    if (rst) begin
        out <= 4'd0; // Reset the register to zero
    end else begin
        // Calculate the feedback value by XORing the most significant bit and the second most significant bit
        reg [3:0] feedback;
        feedback[0] = ~(out[3] ^ out[2]); // Invert the result of the XOR operation
        // Shift the register to the left and insert the new feedback value at the LSB
        out <= {out[2:0], feedback[0]};
    end
end

endmodule