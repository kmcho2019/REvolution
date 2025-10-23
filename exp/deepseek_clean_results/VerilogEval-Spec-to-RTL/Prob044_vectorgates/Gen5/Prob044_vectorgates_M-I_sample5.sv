module TopModule (
    input  [2:0] a,               // 3-bit input A
    input  [2:0] b,               // 3-bit input B
    output [2:0] out_or_bitwise,  // Bitwise OR result (A | B)
    output       out_or_logical,   // Logical OR result (|(A | B))
    output [5:0] out_not          // Concatenated NOT results {~B, ~A}
);

    // Bitwise OR between inputs A and B
    assign out_or_bitwise = a | b;

    // Logical OR (reduction OR of bitwise result)
    assign out_or_logical = |out_or_bitwise;

    // Concatenated NOT operations:
    // - Upper 3 bits: inverse of B
    // - Lower 3 bits: inverse of A
    assign out_not = {~b, ~a};

endmodule