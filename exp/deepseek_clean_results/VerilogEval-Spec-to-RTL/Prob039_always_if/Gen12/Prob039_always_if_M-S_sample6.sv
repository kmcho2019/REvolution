module TopModule (
    input a,
    input b,
    input sel_b1,
    input sel_b2,
    output out_assign,
    output reg out_always
);
    // Assign-based implementation
    assign out_assign = (sel_b1 & sel_b2) ? b : a;

    // Always-based implementation
    always @(*) begin
        if (sel_b1 & sel_b2) begin
            out_always = b;
        end else begin
            out_always = a;
        end
    end
endmodule