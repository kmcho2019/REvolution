module TopModule (
    input a,
    input b,
    input sel_b1,
    input sel_b2,
    output out_assign,
    output reg out_always
);
    wire select_b = sel_b1 & sel_b2;
    
    // Continuous assignment implementation
    assign out_assign = select_b ? b : a;

    // Procedural always implementation with same style
    always @(*) begin
        out_always = select_b ? b : a;
    end
endmodule