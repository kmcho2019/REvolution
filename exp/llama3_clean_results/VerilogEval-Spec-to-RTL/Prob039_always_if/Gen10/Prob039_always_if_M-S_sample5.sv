// The top module encapsulates the direct and procedural assignment logic
module TopModule(
    input  a,
    input  b,
    input  sel_b1,
    input  sel_b2,
    output out_assign,
    output logic out_always
);

// Use assign statement for direct assignment, optimizing for area and power
assign out_assign = (sel_b1 && sel_b2)? b : a;

// Use always block with procedural if statement for procedural assignment
always_comb begin
    out_always = (sel_b1 && sel_b2)? b : a;
end

endmodule