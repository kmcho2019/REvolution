module TopModule(
    input  a,
    input  b,
    input  sel_b1,
    input  sel_b2,
    output reg out_always,
    output out_assign
);

// Procedural combinational block implements the mux
always @(*) begin
    if (sel_b1 & sel_b2)
        out_always = b;
    else
        out_always = a;
end

// Continuous assignment reuses the procedural output
assign out_assign = out_always;

endmodule