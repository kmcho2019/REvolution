module LFSR(
    input clk,
    input rst,
    output reg [3:0] out
);

always @(posedge clk or posedge rst) begin
    if (rst) begin
        // Initialize the register to zero on reset
        out <= 4'b0000;
    end else begin
        // Calculate the feedback signal
        reg fb;
        assign fb = ~(out[3] ^ out[2]);
        
        // Shift the bits to the left and insert the feedback value
        out <= {out[2:0], fb};
    end
end

endmodule