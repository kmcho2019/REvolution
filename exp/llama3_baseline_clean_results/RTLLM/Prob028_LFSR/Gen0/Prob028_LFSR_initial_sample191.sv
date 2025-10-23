module LFSR(
    input clk,
    input rst,
    output reg [3:0] out
);

always @ (posedge clk) begin
    if (rst) begin
        out <= 4'b0000; // Reset the register to zero on active high reset
    end else begin
        // Calculate the feedback by XORing MSB and second MSB, then inverting
        reg fb;
        fb = ~(out[3] ^ out[2]);
        
        // Shift the bits left and insert the new feedback at the LSB
        out <= {out[2:0], fb};
    end
end

endmodule