module TopModule(
    input  clk,
    input  in,
    output out
);

reg out_reg; // internal register for the flip-flop output
assign out = out_reg;

always @ (posedge clk) begin
    out_reg <= in ^ out;
end

endmodule