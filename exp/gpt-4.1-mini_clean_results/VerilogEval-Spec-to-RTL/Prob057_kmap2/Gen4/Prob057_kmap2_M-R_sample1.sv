module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

// Decode cd into one-hot signals for each row
wire cd_00 = ~c & ~d;
wire cd_01 = ~c &  d;
wire cd_11 =  c &  d;
wire cd_10 =  c & ~d;

// Conditions on a,b for each cd row based on K-map
// Row cd=00 (cd_00): out=1 for ab=00,01,10 => a=0 or b=0 except ab=11
wire row_00 = cd_00 & (~a | ~b);

// Row cd=01 (cd_01): out=1 for ab=00,10 => a=0 and b=0 or 1 but excludes ab=01 and 11
wire row_01 = cd_01 & (~a & ~b | ~a & b);

// Row cd=11 (cd_11): out=1 for ab=01,11,10 => b=1 or a=1 except ab=00 (a=0,b=0)
wire row_11 = cd_11 & (b | a);

// Row cd=10 (cd_10): out=1 for ab=00,01 => a=0 regardless of b, and also b=0 for ab=00
wire row_10 = cd_10 & (~a & ~b | ~a & b);

// Combine all rows
assign out = row_00 | row_01 | row_11 | row_10;

endmodule