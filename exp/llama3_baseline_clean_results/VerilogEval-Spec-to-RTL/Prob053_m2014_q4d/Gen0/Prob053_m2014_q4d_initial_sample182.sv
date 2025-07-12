module TopModule(
    input clk,
    input in,
    output reg out
);

reg out_reg; // Internal register for the flip-flop output

always @(posedge clk) begin
    out_reg <= in ^ out;
end

assign out = out_reg;

endmodule