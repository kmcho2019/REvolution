module LFSR(
    input clk,
    input rst,
    output reg [3:0] out
);

always @(posedge clk) begin
    if (rst) begin
        // Reset the LFSR to zero when rst is high
        out <= 4'b0000;
    end else begin
        // Calculate the feedback signal by XORing the most significant bit and the second most significant bit
        reg fb;
        fb = out[3] ^ out[2];
        
        // Shift the bits to the left and insert the feedback value at the LSB
        out <= {out[2:0], ~fb}; // Invert the feedback value as per the problem statement
    end
end

endmodule