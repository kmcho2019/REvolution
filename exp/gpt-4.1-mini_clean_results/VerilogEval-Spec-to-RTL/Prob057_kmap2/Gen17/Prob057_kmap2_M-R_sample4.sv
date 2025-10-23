module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

    // Inverted inputs shared once
    wire na = ~a;
    wire nb = ~b;
    wire nc = ~c;
    wire nd = ~d;

    // Common OR terms
    wire na_or_nb = na | nb;  // ~a | ~b
    wire a_or_b  = a  | b;   // a | b

    // Direct combinational assignment without intermediate groups
    assign out = (nc & nd & na_or_nb)     // Group 1
               | (nc & d  & nb)           // Group 2
               | (c  & nd & na)           // Group 3
               | (c  & d  & a_or_b);      // Group 4

endmodule