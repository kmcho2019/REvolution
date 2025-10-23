// The top module directly implements the required 2-to-1 multiplexer logic
module TopModule(
    input  a,
    input  b,
    input  sel_b1,
    input  sel_b2,
    output out_assign,
    output logic out_always
);

// Direct assignment logic
assign out_assign = (sel_b1 && sel_b2)? b : a;

// Procedural assignment logic using always_comb for combinational logic
always_comb begin
    out_always = (sel_b1 && sel_b2)? b : a;
end

endmodule