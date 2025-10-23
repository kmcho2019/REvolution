module LFSR(
    input clk, 
    input rst, 
    output reg [3:0] out
);

always @ (posedge clk or posedge rst) begin
    if (rst) begin
        // Reset the register to zero when rst is high
        out <= 4'b0000;
    end else begin
        // Calculate the feedback signal by XORing the MSB and the second MSB, and then inverting the result
        reg [3:0] next_out;
        next_out = {out[2:0], ~(out[3] ^ out[2])};
        
        // Shift the bits in the register to the left and insert the new feedback value at the LSB
        out <= next_out;
    end
end

endmodule