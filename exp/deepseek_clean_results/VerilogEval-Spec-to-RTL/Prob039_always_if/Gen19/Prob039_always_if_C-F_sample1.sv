module TopModule (
    input a,
    input b,
    input sel_b1,
    input sel_b2,
    output out_assign,
    output out_always
);
    // Shared selection logic
    wire select_b = sel_b1 & sel_b2;

    // Continuous assignment implementation
    assign out_assign = select_b ? b : a;

    // Procedural implementation (using continuous assignment for efficiency)
    // Note: Using 'assign' instead of 'reg' since this is combinational logic
    assign out_always = select_b ? b : a;
    
    // Alternative procedural implementation if register is required:
    // reg out_always_reg;
    // always @(*) begin
    //     out_always_reg = select_b ? b : a;
    // end
    // assign out_always = out_always_reg;
endmodule