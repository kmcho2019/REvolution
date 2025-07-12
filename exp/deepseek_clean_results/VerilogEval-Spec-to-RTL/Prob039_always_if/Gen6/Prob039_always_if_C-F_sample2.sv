module TopModule (
    input a,
    input b,
    input sel_b1,
    input sel_b2,
    output out_assign,
    output reg out_always
);

    // Clear signal naming for selection condition
    wire select_b = sel_b1 & sel_b2;

    // Concise ternary operator for continuous assignment
    assign out_assign = select_b ? b : a;

    // Matching procedural assignment
    always @(*) begin
        out_always = select_b ? b : a;
    end

endmodule