module TopModule (
    input a,
    input b,
    input sel_b1,
    input sel_b2,
    output out_assign,
    output out_always
);
    wire select_b = sel_b1 & sel_b2;
    
    // Both implementations now use the shared selection logic
    assign out_assign = select_b ? b : a;
    assign out_always = select_b ? b : a;
endmodule