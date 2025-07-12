module TopModule (
    input a,
    input b,
    input c,
    input d,       // Unused input
    output q
);

    // Implement q = (b OR c) AND NOT(a AND NOT(b) AND NOT(c))
    assign q = (b | c) & ~(a & ~b & ~c);

endmodule