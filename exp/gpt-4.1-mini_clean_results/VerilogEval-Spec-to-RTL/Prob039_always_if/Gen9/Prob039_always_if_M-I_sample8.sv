module TopModule(
    input  a,
    input  b,
    input  sel_b1,
    input  sel_b2,
    output out_assign,
    output reg out_always
);

// Continuous assignment implementing the mux logic
assign out_assign = (sel_b1 & sel_b2) ? b : a;

// Procedural assignment implementing the mux logic using if statement
always @(*) begin
    if (sel_b1 & sel_b2)
        out_always = b;
    else
        out_always = a;
end

endmodule