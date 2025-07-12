module TopModule(
    input  a,
    input  b,
    input  sel_b1,
    input  sel_b2,
    output out_assign,
    output reg out_always
);

wire select_b;
assign select_b = sel_b1 & sel_b2;

assign out_assign = select_b ? b : a;

always @(*) begin
    case (select_b)
        1'b1: out_always = b;
        1'b0: out_always = a;
        default: out_always = a; // default case for completeness
    endcase
end

endmodule