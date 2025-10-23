module LFSR(
    input clk,
    input rst,
    output reg [3:0] out
);

always @(posedge clk or posedge rst) begin
    if (rst) begin
        out <= 4'b0000; // Reset the register to zero on rising edge of rst
    end else begin
        // Calculate the feedback signal by XORing the most significant and second most significant bits
        // and then inverting the result
        out <= {out[2:0], ~(out[3] ^ out[2])};
    end
end

endmodule