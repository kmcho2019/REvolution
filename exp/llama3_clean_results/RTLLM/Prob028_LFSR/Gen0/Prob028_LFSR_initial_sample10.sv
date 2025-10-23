module LFSR(
    input clk,
    input rst,
    output [3:0] out
);

reg [3:0] out_reg;

always @ (posedge clk) begin
    if (rst) begin
        out_reg <= 4'd0;
    end else begin
        out_reg <= {out_reg[2:0], ~(out_reg[3] ^ out_reg[2])};
    end
end

assign out = out_reg;

endmodule