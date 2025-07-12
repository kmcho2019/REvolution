module LFSR(
    input clk, 
    input rst, 
    output reg [3:0] out
);

// LFSR logic
always @ (posedge clk or posedge rst) begin
    if (rst) begin
        // Reset to zero, but consider adding an input for initial value for more versatility
        out <= 4'b0000; 
    end else begin
        // Calculate feedback by XORing MSB and second MSB, and inverting the result
        // Directly assign the feedback to out without an intermediate variable
        out <= {out[2:0], ~(out[3] ^ out[2])};
    end
end

endmodule