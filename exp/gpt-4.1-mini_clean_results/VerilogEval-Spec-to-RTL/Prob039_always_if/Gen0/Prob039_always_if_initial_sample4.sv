module TopModule(
    input  a,
    input  b,
    input  sel_b1,
    input  sel_b2,
    output out_assign,
    output reg out_always
);

// Continuous assignment using a ternary operator
assign out_assign = (sel_b1 && sel_b2) ? b : a;

// Procedural block using if statement
always @(*) begin
    if (sel_b1 && sel_b2)
        out_always = b;
    else
        out_always = a;
end

endmodule