module LFSR(
    input clk,
    input rst,
    output reg [3:0] out
);

always @(posedge clk) begin
    if (rst) begin
        out <= 4'b0000;
    end else begin
        // calculate the feedback value by XORing out[3] and out[2], and then inverting the result
        out <= {out[2:0], ~(out[3] ^ out[2])};
    end
end

endmodule