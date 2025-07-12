module TopModule (
    input  a,
    input  b,
    input  sel_b1,
    input  sel_b2,
    output out_assign,
    output reg out_always
);

wire sel_b;
assign sel_b = sel_b1 & sel_b2;

assign out_assign = sel_b ? b : a;

always @(*) begin
    if (sel_b)
        out_always = b;
    else
        out_always = a;
end

endmodule