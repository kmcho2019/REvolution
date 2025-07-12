module TopModule(
    input a,
    input b,
    input c,
    input d,
    output out
);
    wire not_b;
    wire c_and_not_b;
    
    not(not_b, b);
    and(c_and_not_b, c, not_b);
    or(out, a, c_and_not_b);
endmodule