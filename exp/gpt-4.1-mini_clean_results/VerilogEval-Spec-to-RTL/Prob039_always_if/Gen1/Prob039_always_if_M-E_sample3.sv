module TopModule (
    input  a,
    input  b,
    input  sel_b1,
    input  sel_b2,
    output out_assign,
    output reg out_always
);

wire select;
assign select = sel_b1 & sel_b2;

assign out_assign = select ? b : a;

always @(*) begin
    case (select)
        1'b1: out_always = b;
        default: out_always = a;
    endcase
end

endmodule