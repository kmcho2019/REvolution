module TopModule(
    input a,
    input b,
    output out
);

// Explicit instantiation of a 2-input AND gate primitive
and U_and (out, a, b);

endmodule