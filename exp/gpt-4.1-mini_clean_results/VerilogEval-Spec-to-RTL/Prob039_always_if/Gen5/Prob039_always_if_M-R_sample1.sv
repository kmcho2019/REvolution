module TopModule (
    input  a,
    input  b,
    input  sel_b1,
    input  sel_b2,
    output out_assign,
    output reg out_always
);

// Procedural 2-to-1 mux using inline condition
always @(*) begin
    if (sel_b1 & sel_b2)
        out_always = b;
    else
        out_always = a;
end

// Continuous assignment 2-to-1 mux using inline condition
assign out_assign = (sel_b1 & sel_b2) ? b : a;

endmodule