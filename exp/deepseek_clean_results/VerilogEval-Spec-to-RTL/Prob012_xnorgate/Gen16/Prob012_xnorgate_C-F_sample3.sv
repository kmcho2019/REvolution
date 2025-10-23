module TopModule (
    input a,
    input b,
    output out
);
    // Direct gate-level implementation of XNOR
    // Equivalent to: out = (a == b)
    assign out = ~(a ^ b);
endmodule