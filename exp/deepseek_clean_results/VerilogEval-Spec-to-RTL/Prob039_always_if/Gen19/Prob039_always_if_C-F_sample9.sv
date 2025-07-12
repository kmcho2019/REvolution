module TopModule (
    input a,
    input b,
    input sel_b1,
    input sel_b2,
    output out_assign,
    output out_always
);
    // Shared selection logic - compute once
    wire select_b = sel_b1 & sel_b2;

    // Implementation 1: Continuous assignment (combinational logic)
    assign out_assign = select_b ? b : a;

    // Implementation 2: Procedural block (combinational logic)
    always @(*) begin
        if (select_b)
            out_always = b;
        else
            out_always = a;
    end
endmodule