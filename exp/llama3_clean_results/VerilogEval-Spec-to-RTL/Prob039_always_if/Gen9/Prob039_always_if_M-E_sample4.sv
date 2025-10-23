module TopModule(
    input  a,
    input  b,
    input  sel_b1,
    input  sel_b2,
    output out_assign,
    output logic out_always
);

// Direct assignment using a simplified logic expression
assign out_assign = (sel_b1 && sel_b2) ? b : a;

// Procedural assignment using a combination of AND, OR, and NOT gates
always @(*) begin
    logic sel_b;
    sel_b = sel_b1 && sel_b2;
    out_always = sel_b ? b : a;
end

endmodule