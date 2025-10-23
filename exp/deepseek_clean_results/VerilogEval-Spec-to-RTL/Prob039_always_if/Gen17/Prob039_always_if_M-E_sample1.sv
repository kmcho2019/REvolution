module TopModule (
    input a,
    input b,
    input sel_b1,
    input sel_b2,
    output out_assign,
    output reg out_always
);
    // Combined selection signal
    wire sel_both = sel_b1 & sel_b2;

    // Continuous assignment using bitwise operations
    assign out_assign = (a & ~sel_both) | (b & sel_both);

    // Procedural implementation using same bitwise approach
    always @(*) begin
        out_always = (a & ~sel_both) | (b & sel_both);
    end
endmodule