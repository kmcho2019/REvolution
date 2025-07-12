module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

wire row_parity;
wire col_parity;

// Compute parity of row inputs (c,d)
assign row_parity = c ^ d;

// Compute parity of column inputs (a,b)
assign col_parity = a ^ b;

// Output is parity of row_parity and col_parity
assign out = row_parity ^ col_parity;

endmodule