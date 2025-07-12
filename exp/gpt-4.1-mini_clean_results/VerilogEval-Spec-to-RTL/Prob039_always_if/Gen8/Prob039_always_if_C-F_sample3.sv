module TopModule(
    input  a,
    input  b,
    input  sel_b1,
    input  sel_b2,
    output reg out_always,
    output      out_assign
);

wire enable_b = sel_b1 & sel_b2;
reg mux_out;

always @(*) begin
    if (enable_b)
        mux_out = b;
    else
        mux_out = a;
end

assign out_assign = mux_out;
always @(*) out_always = mux_out;

endmodule