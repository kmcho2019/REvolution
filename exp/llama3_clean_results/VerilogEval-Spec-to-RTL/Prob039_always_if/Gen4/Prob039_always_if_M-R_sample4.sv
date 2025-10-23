module TopModule(
    input  a,
    input  b,
    input  sel_b1,
    input  sel_b2,
    output reg out_assign,
    output reg out_always
);

// Combinational Logic using ternary operator
assign out_assign = (sel_b1 && sel_b2)? b : a;

// Procedural Logic using if-else statement and ternary operator
always @(*) begin
    out_always = (sel_b1 && sel_b2)? b : a;
end

endmodule