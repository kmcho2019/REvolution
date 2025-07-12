module TopModule (
    input  a,
    input  b,
    input  sel_b1,
    input  sel_b2,
    output out_assign,
    output reg out_always
);

wire mux_result = (sel_b1 & sel_b2) ? b : a;

assign out_assign = mux_result;

always @(*) begin
    out_always = mux_result;
end

endmodule