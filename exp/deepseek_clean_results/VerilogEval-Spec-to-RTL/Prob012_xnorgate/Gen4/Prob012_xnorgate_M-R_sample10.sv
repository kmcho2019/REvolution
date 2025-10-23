module TopModule (
    input a,
    input b,
    output out
);
    wire a_and_b, not_a_and_not_b, not_a, not_b;
    
    not(not_a, a);
    not(not_b, b);
    and(a_and_b, a, b);
    and(not_a_and_not_b, not_a, not_b);
    or(out, a_and_b, not_a_and_not_b);
endmodule