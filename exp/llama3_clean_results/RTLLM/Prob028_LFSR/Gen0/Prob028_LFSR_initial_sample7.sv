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
        // Calculate the feedback signal by XORing MSB and second MSB, then inverting
        reg fb;
        assign fb = ~(out[3] ^ out[2]);
        
        // Shift the bits left and insert the new feedback value at the LSB
        out <= {out[2:0], fb};
    end
end

endmodule