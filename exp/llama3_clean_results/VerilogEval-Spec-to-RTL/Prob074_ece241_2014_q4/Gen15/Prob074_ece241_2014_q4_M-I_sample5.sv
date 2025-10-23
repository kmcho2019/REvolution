module TopModule(
    input clk,
    input x,
    output z
);

reg ff_out_xnor;
reg ff_out_and;
reg ff_out_or;

wire xnor_in;
wire and_in;
wire or_in;

assign xnor_in = x ^ ff_out_xnor;
assign and_in = x & ~ff_out_and;
assign or_in = x | ~ff_out_or;

always @(posedge clk) begin
    ff_out_xnor <= xnor_in;
    ff_out_and <= and_in;
    ff_out_or <= or_in;
end

assign z = ~(ff_out_xnor | ff_out_and | ff_out_or);

endmodule