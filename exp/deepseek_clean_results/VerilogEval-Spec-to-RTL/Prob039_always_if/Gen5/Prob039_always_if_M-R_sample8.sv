module TopModule (
    input  a,
    input  b,
    input  sel_b1,
    input  sel_b2,
    output out_assign,
    output reg out_always
);
    // Shared selection logic
    wire select_b = sel_b1 & sel_b2;

    // Assign-based implementation
    assign out_assign = select_b ? b : a;

    // Always-based implementation
    always @(*) begin
        if (select_b)
            out_always = b;
        else
            out_always = a;
    end
endmodule