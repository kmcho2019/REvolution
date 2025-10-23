module LFSR (
    input clk,
    input rst,
    output reg [3:0] out
);

always @ (posedge clk or posedge rst) begin
    if (rst) begin
        // Initialize the register to zero on reset
        out <= 4'b0000;
    end else begin
        // Calculate the feedback signal by XORing the MSB and the second MSB, and inverting the result
        reg fb;
        assign fb = ~(out[3] ^ out[2]);
        
        // Shift the register left and insert the new feedback value at the LSB
        out <= {out[2:0], fb};
    end
end

endmodule