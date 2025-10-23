module TopModule (
    input  wire a,
    input  wire b,
    input  wire sel_b1,
    input  wire sel_b2,
    output wire out_assign,
    output reg  out_always
);

wire sel_b = sel_b1 && sel_b2;
wire mux_out = sel_b ? b : a;

assign out_assign = mux_out;

always @(*) begin
    if (sel_b)
        out_always = b;
    else
        out_always = a;
end

endmodule