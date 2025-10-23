module TopModule (
    input a,
    input b,
    input sel_b1,
    input sel_b2,
    output out_assign,
    output reg out_always
);
    // Shared selection logic
    wire select_b = sel_b1 & sel_b2;

    // Continuous assignment using shared logic
    assign out_assign = select_b ? b : a;

    // Procedural implementation using shared logic
    always @(*) begin
        out_always = select_b ? b : a;
    end
endmodule