module LFSR(
    input clk, 
    input rst, 
    output reg [3:0] out
);

// LFSR logic
always @ (posedge clk or posedge rst) begin
    if (rst) begin
        out <= 4'b0000; // Initialize to zero on reset
    end else begin
        // Calculate feedback by XORing MSB and second MSB, and inverting the result
        reg feedback;
        feedback = ~(out[3] ^ out[2]);
        
        // Shift bits to the left and insert feedback as the new LSB
        out <= {out[2:0], feedback};
    end
end

endmodule