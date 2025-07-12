module LFSR(
    input clk,
    input rst,
    output reg [3:0] out
);

always @(posedge clk or posedge rst) begin
    if (rst) begin
        // Reset the register to zero
        out <= 4'd0;
    end else begin
        // Calculate the feedback signal
        reg fb;
        fb = ~(out[3] ^ out[2]);
        
        // Shift the bits and insert the new feedback value
        out <= {out[2:0], fb};
    end
end

endmodule