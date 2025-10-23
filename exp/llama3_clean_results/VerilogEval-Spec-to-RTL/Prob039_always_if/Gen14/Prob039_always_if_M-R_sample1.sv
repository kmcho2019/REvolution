// The top module encapsulates both direct and procedural assignment logic
module TopModule(
    input  a,
    input  b,
    input  sel_b1,
    input  sel_b2,
    output out_assign,
    output logic out_always
);

// Direct assignment using assign statement
assign out_assign = (sel_b1 && sel_b2)? b : a;

// Procedural assignment using always block
always @(*) begin
    out_always = (sel_b1 && sel_b2)? b : a;
end

endmodule