module TopModule (
    input  a,
    input  b,
    input  sel_b1,
    input  sel_b2,
    output out_assign,
    output reg out_always
);

wire select_b = sel_b1 & sel_b2;

assign out_assign = select_b ? b : a;

always @(*) begin
    if (select_b)
        out_always = b;
    else
        out_always = a;
end

endmodule