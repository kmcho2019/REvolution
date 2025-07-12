module TopModule(
    input  a,
    input  b,
    input  sel_b1,
    input  sel_b2,
    output reg out_always,
    output out_assign
);

// Continuous assignment implementing the mux logic directly
assign out_assign = (sel_b1 & sel_b2) ? b : a;

// Procedural combinational block implementing the same mux logic separately
always @(*) begin
    if (sel_b1 & sel_b2)
        out_always = b;
    else
        out_always = a;
end

endmodule