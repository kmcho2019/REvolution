module TopModule (
    input a,
    input b,
    output out
);
    wire a_eq_b = ~(a ^ b);  // Intermediate equality check
    assign out = (a_eq_b & a) | (~a_eq_b & ~a);
endmodule