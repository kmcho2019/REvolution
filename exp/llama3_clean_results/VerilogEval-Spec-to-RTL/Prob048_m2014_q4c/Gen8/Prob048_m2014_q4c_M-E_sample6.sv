module TopModule(
    input clk,
    input d,
    input r,
    output reg q
);

reg sel;
reg mux_out;

always @(*) begin
    sel = r;
    mux_out = (r) ? 1'b0 : d;
end

always @(posedge clk) begin
    q <= mux_out;
end

endmodule