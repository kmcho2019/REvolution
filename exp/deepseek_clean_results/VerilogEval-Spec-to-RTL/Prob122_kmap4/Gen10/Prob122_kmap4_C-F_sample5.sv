module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);
    // Compute row and column parities separately
    wire row_parity = c ^ d;
    wire col_parity = a ^ b;
    
    // Combine to form the checkerboard pattern
    assign out = row_parity ^ col_parity;
endmodule