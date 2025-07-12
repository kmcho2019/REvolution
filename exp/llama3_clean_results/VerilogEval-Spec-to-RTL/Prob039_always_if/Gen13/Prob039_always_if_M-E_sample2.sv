module TopModule(
    input  a,
    input  b,
    input  sel_b1,
    input  sel_b2,
    output out_assign,
    output out_always
);

// Combinational logic using gates for out_assign
wire sel_b; // Signal indicating both sel_b1 and sel_b2 are true
assign sel_b = sel_b1 && sel_b2; // Using AND operation

assign out_assign = sel_b ? b : a; // Conditional assignment

// Procedural logic using gates for out_always
logic out_always_wire; // Intermediate wire for out_always
always @(*) begin
    logic sel_b_procedural; // Procedural version of sel_b
    assign sel_b_procedural = sel_b1 && sel_b2; // Same AND operation as before
    
    // Implementing the conditional logic using gates within the procedural block
    // This demonstrates how the same logic can be achieved procedurally
    out_always_wire = sel_b_procedural ? b : a;
    
    assign out_always = out_always_wire; // Assigning the result to out_always
end

endmodule