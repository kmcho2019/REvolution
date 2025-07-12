module TopModule (
    input a,
    input b,
    input sel_b1,
    input sel_b2,
    output out_assign,
    output out_always
);
    // Compute selection signal once
    wire select_b = sel_b1 & sel_b2;

    // Assign-based implementation (ternary operator)
    assign out_assign = select_b ? b : a;

    // Always-based implementation (ternary operator)
    always @(*) begin
        out_always = select_b ? b : a;
    end
endmodule