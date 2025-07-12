module LFSR(
    input clk, 
    input rst, 
    output reg [3:0] out
);

always @ (posedge clk or posedge rst) begin
    if (rst) begin
        // If reset is high, initialize the register to zero
        out <= 4'b0000;
    end else begin
        // Calculate the feedback signal by XORing the MSB and the second MSB, then inverting the result
        reg feedback;
        feedback = ~(out[3] ^ out[2]);
        
        // Shift the bits in the register left and insert the new feedback value at the LSB
        out <= {out[2:0], feedback};
    end
end

endmodule