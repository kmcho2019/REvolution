module TopModule (
    input a,
    input b,
    input sel_b1,
    input sel_b2,
    output out_assign,
    output out_always
);

    // Common selection signal
    wire select_b = sel_b1 & sel_b2;

    // Continuous assignment implementation
    assign out_assign = select_b ? b : a;

    // Procedural implementation
    always @(*) begin
        if (select_b) begin
            out_always = b;
        end else begin
            out_always = a;
        end
    end

endmodule