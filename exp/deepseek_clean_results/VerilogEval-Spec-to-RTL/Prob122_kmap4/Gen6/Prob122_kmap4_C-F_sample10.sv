module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);
    // Row pattern (alternates every row: a^b)
    wire row_pattern = a ^ b;
    // Column pattern (alternates every column: c^d)
    wire col_pattern = c ^ d;
    
    // Final output combines patterns to create checkerboard
    assign out = row_pattern ^ col_pattern;
endmodule