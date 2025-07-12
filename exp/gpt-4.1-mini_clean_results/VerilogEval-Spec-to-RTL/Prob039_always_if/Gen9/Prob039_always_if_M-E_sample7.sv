module TopModule (
    input  a,
    input  b,
    input  sel_b1,
    input  sel_b2,
    output out_assign,
    output reg out_always
);

wire sel_enable;

assign sel_enable = sel_b1 & sel_b2;

// Use bitwise operation for muxing in continuous assign
assign out_assign = (a & ~sel_enable) | (b & sel_enable);

always @(*) begin
    case(sel_enable)
        1'b0: out_always = a;
        1'b1: out_always = b;
        default: out_always = a; // default fallback, though default not necessary here
    endcase
end

endmodule