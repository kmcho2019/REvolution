module TopModule(
    input a,
    input b,
    input c,
    input d,
    output out
);
    wire b_not;
    wire and_term;
    
    not(b_not, b);
    and(and_term, b_not, c);
    or(out, a, and_term);
endmodule