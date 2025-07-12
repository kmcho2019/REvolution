module LFSR (
    input clk,
    input rst,
    output [3:0] out
);

reg [3:0] out;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        out <= 4'b0000;
    end else begin
        out <= {out[2] ^ out[3], out[3:1]};
    end
end

endmodule