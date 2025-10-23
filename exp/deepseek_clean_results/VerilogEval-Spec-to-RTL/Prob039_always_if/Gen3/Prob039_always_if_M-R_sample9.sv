module TopModule (
    input a,
    input b,
    input sel_b1,
    input sel_b2,
    output out_assign,
    output out_always
);
    // Selection signal - true when both sel_b1 and sel_b2 are true
    wire select_b = sel_b1 & sel_b2;
    
    // Assign-based implementation
    assign out_assign = select_b ? b : a;
    
    // Alternative implementation using continuous assignment instead of always block
    assign out_always = select_b ? b : a;
endmodule