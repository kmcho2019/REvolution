module TopModule(
    input  clk,
    input  in,
    output out
);

reg out_reg; // internal reg for output
assign out = out_reg; // continuous assignment for output

always @ (posedge clk) begin
    out_reg <= in ^ out_reg; // XOR and assign to internal reg on posedge clk
end

endmodule