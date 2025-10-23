module LFSR(
    input clk, 
    input rst, 
    output reg [3:0] out
);

always @ (posedge clk or posedge rst) begin
    if (rst) begin
        // Reset the LFSR to zero when the reset signal is high
        out <= 4'd0;
    end else begin
        // Calculate the feedback by XORing the MSB and the second MSB, then invert the result
        reg feedback;
        feedback = ~(out[3] ^ out[2]);
        
        // Shift the bits left and insert the new feedback at the LSB
        out <= {out[2:0], feedback};
    end
end

endmodule