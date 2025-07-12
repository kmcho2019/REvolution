module TopModule (
    input  wire a,
    input  wire b,
    input  wire sel_b1,
    input  wire sel_b2,
    output wire out_assign,
    output reg  out_always
);

// Continuous assignment: select b if both sel_b1 and sel_b2 are high; else a
assign out_assign = (sel_b1 & sel_b2) ? b : a;

// Procedural mux implemented using an always block and if-else statement
always @(*) begin
    if (sel_b1 & sel_b2)
        out_always = b;
    else
        out_always = a;
end

endmodule