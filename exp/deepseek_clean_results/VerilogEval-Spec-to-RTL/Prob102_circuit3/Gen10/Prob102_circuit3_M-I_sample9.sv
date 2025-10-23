module TopModule (
    input a,
    input b,
    input c,
    input d,
    output q
);

    // Using AO22 compound gate if available in library
    // Equivalent to: assign q = (a | b) & (c | d);
    AO22 U1 (.A1(a), .A2(b), .B1(c), .B2(d), .Z(q));

endmodule