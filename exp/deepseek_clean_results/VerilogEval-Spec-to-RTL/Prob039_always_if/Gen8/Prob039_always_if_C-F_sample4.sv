module TopModule (
    input a,
    input b,
    input sel_b1,
    input sel_b2,
    output out_assign,
    output out_always
);
    // Common selection logic
    wire select_b = sel_b1 & sel_b2;
    
    // Assign-based implementation
    assign out_assign = select_b ? b : a;
    
    // Procedural always-based implementation
    always @(*) begin
        out_always = select_b ? b : a;
    end
endmodule