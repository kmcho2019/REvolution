module LFSR(
    input clk, 
    input rst, 
    output reg [3:0] out
);

// Internal signal for feedback calculation
reg feedback;

// LFSR logic
always @ (posedge clk or posedge rst) begin
    if (rst) begin
        // Initialize the register to zero on reset
        out <= 4'b0000;
    end else begin
        // Calculate feedback by XORing MSB and second MSB, and inverting the result
        feedback = ~(out[3] ^ out[2]);
        
        // Shift bits to the left and insert feedback as the new LSB
        out <= {out[2:0], feedback};
    end
end

endmodule