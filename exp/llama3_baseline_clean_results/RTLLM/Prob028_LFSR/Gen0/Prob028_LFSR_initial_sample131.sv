module LFSR(
    input clk, 
    input rst, 
    output [3:0] out
);

reg [3:0] out;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        // Synchronous reset: initialize the register to zero when rst is high
        out <= 4'b0000;
    end else begin
        // Calculate the feedback signal by XORing the most significant bit and the second most significant bit
        // and then inverting the result
        wire feedback = ~(out[3] ^ out[2]);
        
        // Shift the bits left and insert the new feedback value at the least significant bit (LSB)
        out <= {out[2:0], feedback};
    end
end

endmodule