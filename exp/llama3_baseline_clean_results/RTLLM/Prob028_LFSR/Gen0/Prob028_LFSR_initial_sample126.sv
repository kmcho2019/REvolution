module LFSR(
    input clk,
    input rst,
    output reg [3:0] out
);

always_ff @(posedge clk or posedge rst) begin
    if (rst) begin
        out <= 4'b0000; // Initialize register to zero on reset
    end else begin
        // Calculate feedback by XORing MSB and second MSB, then invert
        out <= {out[2:0], ~(out[3] ^ out[2])}; // Shift left and insert new feedback at LSB
    end
end

endmodule