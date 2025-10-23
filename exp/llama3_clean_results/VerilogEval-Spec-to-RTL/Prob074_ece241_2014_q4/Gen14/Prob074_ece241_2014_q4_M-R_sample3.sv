module TopModule(
    input clk,
    input x,
    output z
);

reg ff_out_xnor;
reg ff_out_and;
reg ff_out_or;

always @(*) begin
    ff_out_xnor <= x ^ ff_out_xnor;
    ff_out_and <= x & ~ff_out_and;
    ff_out_or <= x | ~ff_out_or;
end

always @(posedge clk) begin
    ff_out_xnor <= ff_out_xnor;
    ff_out_and <= ff_out_and;
    ff_out_or <= ff_out_or;
end

assign z = ~(ff_out_xnor | ff_out_and | ff_out_or);

endmodule