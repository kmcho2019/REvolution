module TopModule (
    input a,
    input b,
    input sel_b1,
    input sel_b2,
    output out_assign,
    output out_always
);
    // Single mux implementation shared by both outputs
    assign out_assign = (sel_b1 & sel_b2) ? b : a;
    assign out_always = out_assign;  // Direct connection since functionality is identical
endmodule