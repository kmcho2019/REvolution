module TopModule (
    input a,
    input b,
    input sel_b1,
    input sel_b2,
    output out_assign,
    output out_always
);
    // Shared selection logic
    wire select_b = sel_b1 & sel_b2;

    // Single optimized implementation
    assign out_assign = select_b ? b : a;
    assign out_always = out_assign;  // Maintain interface while sharing logic
endmodule