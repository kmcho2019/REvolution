module TopModule (
    input  a,
    input  b,
    input  sel_b1,
    input  sel_b2,
    output out_assign,
    output reg out_always
);

// Combinational assign statement using ternary operator
assign out_assign = (sel_b1 & sel_b2) ? b : a;

// Procedural always block using if-else for selection
always @(*) begin
    if (sel_b1 & sel_b2)
        out_always = b;
    else
        out_always = a;
end

endmodule