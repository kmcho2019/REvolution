module LFSR(
    input clk,
    input rst,
    output reg [3:0] out
);

always @(posedge clk or posedge rst) begin
    if (rst) begin
        // Reset the LFSR to zero on active high reset
        out <= 4'd0;
    end else begin
        // Compute the feedback by XORing the most significant and second most significant bits
        // and then invert the result
        reg feedback;
        feedback = ~(out[3] ^ out[2]);
        
        // Shift the bits to the left and insert the new feedback at the LSB
        out <= {out[2:0], feedback};
    end
end

endmodule