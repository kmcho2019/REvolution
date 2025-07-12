module LFSR(
    input clk,
    input rst,
    output reg [3:0] out
);

always @(posedge clk) begin
    if (rst) begin
        // Reset the LFSR to zero when reset is high
        out <= 4'b0000;
    end else begin
        // Calculate the feedback signal by XORing the most significant bit and the second most significant bit, then inverting the result
        reg feedback;
        feedback = ~(out[3] ^ out[2]);
        
        // Shift the bits left and insert the feedback signal at the least significant bit
        out <= {out[2:0], feedback};
    end
end

endmodule