module TopModule (
    input a,
    input b,
    input sel_b1,
    input sel_b2,
    output out_assign,
    output out_always
);
    wire sel_both = sel_b1 & sel_b2;
    
    // Assign-based mux
    assign out_assign = sel_both ? b : a;
    
    // Always-based mux
    always @(*) begin
        out_always = sel_both ? b : a;
    end
endmodule