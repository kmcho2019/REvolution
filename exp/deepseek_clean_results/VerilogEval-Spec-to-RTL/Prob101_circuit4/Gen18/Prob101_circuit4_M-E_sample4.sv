module TopModule (
    input  a, b, c, d,
    output q
);
    // Conditional OR gate with enable
    // Output is (b OR c) only when a is low
    // Input d remains unused
    assign q = ~a & (b | c);
endmodule