// The top module encapsulates the direct and procedural assignment logic
module TopModule(
    input  a,
    input  b,
    input  sel_b1,
    input  sel_b2,
    output out_assign,
    output logic out_always
);

// Use assign statement for direct assignment
assign out_assign = (sel_b1 && sel_b2) ? b : a;

// Use always block for procedural assignment
always @(*) begin
    out_always = (sel_b1 && sel_b2) ? b : a;
end

endmodule