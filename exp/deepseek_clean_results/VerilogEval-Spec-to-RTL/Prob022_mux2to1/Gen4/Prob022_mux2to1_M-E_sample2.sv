module TopModule (
    input a,
    input b,
    input sel,
    output out
);
    wire sel_n;
    wire a_gated, b_gated;
    
    not(sel_n, sel);
    and(a_gated, a, sel_n);
    and(b_gated, b, sel);
    or(out, a_gated, b_gated);
endmodule