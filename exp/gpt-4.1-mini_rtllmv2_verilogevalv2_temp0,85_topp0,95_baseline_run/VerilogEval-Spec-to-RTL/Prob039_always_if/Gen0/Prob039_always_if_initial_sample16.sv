module TopModule(
    input  a,
    input  b,
    input  sel_b1,
    input  sel_b2,
    output out_assign,
    output reg out_always
);

wire sel = sel_b1 & sel_b2;

// Continuous assignment for out_assign
assign out_assign = sel ? b : a;

// Procedural assignment for out_always
always @(*) begin
    if (sel)
        out_always = b;
    else
        out_always = a;
end

endmodule