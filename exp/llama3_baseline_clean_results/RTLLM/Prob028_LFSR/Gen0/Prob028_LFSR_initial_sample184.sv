module LFSR(
    input clk,
    input rst,
    output reg [3:0] out
);

always @ (posedge clk or posedge rst) begin
    if (rst) begin
        out <= 4'b0000; // Reset the register to zero when rst is high
    end else begin
        // Calculate the feedback signal by XORing the most significant bit and the second most significant bit, then inverting the result
        reg feedback;
        assign feedback = ~(out[3] ^ out[2]);
        
        // Shift the bits left and insert the new feedback value at the least significant bit
        out <= {out[2:0], feedback};
    end
end

endmodule