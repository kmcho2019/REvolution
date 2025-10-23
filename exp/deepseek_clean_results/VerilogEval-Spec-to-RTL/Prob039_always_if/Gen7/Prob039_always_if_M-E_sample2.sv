module TopModule (
    input a,
    input b,
    input sel_b1,
    input sel_b2,
    output out_assign,
    output out_always
);
    // Assign implementation with hierarchical selection
    assign out_assign = sel_b1 ? (sel_b2 ? b : a) : a;

    // Always implementation with identical hierarchical selection
    always @(*) begin
        if (sel_b1) begin
            out_always = sel_b2 ? b : a;
        end else begin
            out_always = a;
        end
    end
endmodule