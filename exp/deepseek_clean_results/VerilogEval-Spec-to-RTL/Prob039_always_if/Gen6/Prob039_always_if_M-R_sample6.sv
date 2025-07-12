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

    // Assign-based implementation
    assign out_assign = select_b ? b : a;

    // Alternative implementation using assign instead of always
    assign out_always = select_b ? b : a;
endmodule