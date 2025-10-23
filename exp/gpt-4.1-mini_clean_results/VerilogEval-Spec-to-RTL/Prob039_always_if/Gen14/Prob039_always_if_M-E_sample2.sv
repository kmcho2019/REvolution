module TopModule (
    input  a,
    input  b,
    input  sel_b1,
    input  sel_b2,
    output out_assign,
    output reg out_always
);

wire sel;

assign sel = sel_b1 & sel_b2;

assign out_assign = sel ? b : a;

always @(*) begin
    case (sel)
        1'b1: out_always = b;
        1'b0: out_always = a;
        default: out_always = 1'bx; // safety default, though sel is single bit
    endcase
end

endmodule