module TopModule (
    input a,
    input b,
    input sel_b1,
    input sel_b2,
    output out_assign,
    output reg out_always
);
    // Shared selection logic - compute once
    wire select_b = sel_b1 & sel_b2;

    // Continuous assignment implementation (concise)
    assign out_assign = select_b ? b : a;

    // Procedural implementation (explicit)
    always @(*) begin
        if (select_b) begin
            out_always = b;
        end else begin
            out_always = a;
        end
    end
endmodule