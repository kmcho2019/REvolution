module TopModule (
    input  a,
    input  b,
    input  sel_b1,
    input  sel_b2,
    output out_assign,
    output reg out_always
);

reg use_b_reg;

// Compute use_b_reg combinationally
always @(*) begin
    use_b_reg = sel_b1 & sel_b2;
end

// Procedural 2-to-1 mux using if-else
always @(*) begin
    if (use_b_reg)
        out_always = b;
    else
        out_always = a;
end

// Continuous assignment 2-to-1 mux using inline condition
assign out_assign = (sel_b1 & sel_b2) ? b : a;

endmodule