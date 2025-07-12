module LFSR (
    input clk,
    input rst,
    output [3:0] out
);

reg [3:0] out;

always @(posedge clk) begin
    if (rst) begin
        // Initialize the register with zero when reset is high
        out <= 4'b0000;
    end else begin
        // Calculate the feedback signal by XORing the most significant bit and the second most significant bit
        reg feedback;
        feedback = ~(out[3] ^ out[2]);
        
        // Shift the bits in the register to the left and insert the new feedback value at the LSB
        out <= {out[2:0], feedback};
    end
end

endmodule