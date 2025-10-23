module LFSR (
    input clk,
    input rst,
    output reg [3:0] out
);

always @(posedge clk or posedge rst) begin
    if (rst) begin
        // Initialize the register to zero when reset is high
        out <= 4'd0;
    end else begin
        // Calculate the feedback signal by XORing the most significant bit and the second most significant bit
        reg feedback;
        feedback = ~(out[3] ^ out[2]);
        
        // Shift the bits left and insert the feedback value at the least significant bit
        out <= {out[2:0], feedback};
    end
end

endmodule