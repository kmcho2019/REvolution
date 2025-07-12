module TopModule (
    input a,
    input b,
    input sel_b1,
    input sel_b2,
    output out_assign,
    output reg out_always
);
    // Assign-based implementation with inlined selection logic
    assign out_assign = (sel_b1 & sel_b2) ? b : a;

    // Always-based implementation with inlined selection logic
    always @(*) begin
        if (sel_b1 & sel_b2)
            out_always = b;
        else
            out_always = a;
    end
endmodule