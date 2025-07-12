module TopModule (
    input  a,
    input  b,
    input  sel_b1,
    input  sel_b2,
    output out_assign,
    output reg out_always
);

wire sel_en = sel_b1 & sel_b2;

// Continuous assignment using bitwise masking to select inputs
assign out_assign = (b & sel_en) | (a & ~sel_en);

// Procedural assignment using ternary operator instead of if-else
always @(*) begin
    out_always = sel_en ? b : a;
end

endmodule