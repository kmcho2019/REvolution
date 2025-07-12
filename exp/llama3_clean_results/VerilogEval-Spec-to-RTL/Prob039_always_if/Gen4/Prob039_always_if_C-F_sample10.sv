module TopModule(
    input  a,
    input  b,
    input  sel_b1,
    input  sel_b2,
    output logic out_assign,
    output logic out_always
);

// Using assign statement for combinational logic
assign out_assign = (sel_b1 && sel_b2) ? b : a;

// Using always block for procedural assignment
always @(*) begin
    out_always = (sel_b1 && sel_b2) ? b : a;
end

endmodule