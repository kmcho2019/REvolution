module TopModule (
    input  a,
    input  b,
    input  sel_b1,
    input  sel_b2,
    output out_assign,
    output reg out_always
);

wire mux_out = (sel_b1 & sel_b2) ? b : a;

assign out_assign = mux_out;

always @(*) begin
    if (out_always !== mux_out)  // Only update if changed to reduce toggling
        out_always = mux_out;
    else
        out_always = out_always;
end

endmodule