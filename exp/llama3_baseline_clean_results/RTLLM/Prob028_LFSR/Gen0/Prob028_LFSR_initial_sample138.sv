module LFSR(
    input clk,
    input rst,
    output reg [3:0] out
);

always @ (posedge clk) begin
    if (rst) begin
        // Synchronous reset, set out to 0 when rst is high
        out <= 4'b0;
    end else begin
        // Calculate the feedback by XORing the MSB and the second MSB, then inverting the result
        reg fb;
        assign fb = ~(out[3] ^ out[2]);
        
        // Shift left and insert the feedback at the LSB
        out <= {out[2:0], fb};
    end
end

endmodule