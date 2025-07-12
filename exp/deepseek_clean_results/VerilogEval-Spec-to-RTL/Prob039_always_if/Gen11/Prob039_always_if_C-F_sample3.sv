module TopModule (
    input  a,
    input  b,
    input  sel_b1,
    input  sel_b2,
    output out_assign,
    output reg out_always
);
    // Shared selection logic: choose b only when both selectors are true
    wire select_b = sel_b1 & sel_b2;

    // Implementation 1: Continuous assignment (combinational logic)
    assign out_assign = select_b ? b : a;

    // Implementation 2: Procedural always block (combinational logic)
    always @(*) begin
        if (select_b) begin
            out_always = b;
        end
        else begin
            out_always = a;
        end
    end
endmodule