module TopModule (
    input a,
    input b,
    input sel,
    output out
);
    wire not_sel;
    wire and_a;
    wire and_b;
    
    not(not_sel, sel);
    and(and_a, not_sel, a);
    and(and_b, sel, b);
    or(out, and_a, and_b);
endmodule