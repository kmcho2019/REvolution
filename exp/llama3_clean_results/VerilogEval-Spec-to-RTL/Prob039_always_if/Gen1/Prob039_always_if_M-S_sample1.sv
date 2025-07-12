module TopModule(
    input  a,
    input  b,
    input  sel_b1,
    input  sel_b2,
    output reg out_assign,
    output reg out_always
);

assign out_assign = (sel_b1 && sel_b2)? b : a;

always @(*)
begin
    out_always = (sel_b1 && sel_b2)? b : a;
end

endmodule