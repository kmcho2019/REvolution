module TopModule(
    input  a,
    input  b,
    input  sel_b1,
    input  sel_b2,
    output out_assign,
    output reg out_always
);

assign out_assign = (~sel_b1 | ~sel_b1) ? a : b;

always @(*) begin
    reg mask;
    mask = sel_b1 & sel_b2;
    out_always = mask ? b : a;
end

endmodule