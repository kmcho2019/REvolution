module TopModule (
    input  a,
    input  b,
    input  sel_b1,
    input  sel_b2,
    output out_assign,
    output reg out_always
);

reg mux_out;

always @(*) begin
    if (sel_b1 && sel_b2)
        mux_out = b;
    else
        mux_out = a;

    out_always = mux_out;
end

assign out_assign = mux_out;

endmodule