module TopModule (
    input  a,
    input  b,
    input  sel_b1,
    input  sel_b2,
    output out_assign,
    output reg out_always
);

wire mux_out;
assign mux_out = (sel_b1 && sel_b2) ? b : a;

assign out_assign = mux_out;

always @(*) begin
    out_always = mux_out;
end

endmodule