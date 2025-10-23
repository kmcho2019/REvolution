module LFSR (
    input clk,
    input rst,
    output reg [3:0] out
);

always @(posedge clk) begin
    if (rst) begin
        out <= 4'b0001; // Non-zero initialization
    end
    else begin
        out <= {out[2:0], out[3] ^ out[2]}; // Standard x^4 + x^3 + 1 polynomial
    end
end

endmodule