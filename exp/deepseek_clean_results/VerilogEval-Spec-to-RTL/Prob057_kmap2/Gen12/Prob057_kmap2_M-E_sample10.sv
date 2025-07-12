module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out
);

// Row (cd) pattern detectors
wire row00 = ~c & ~d;  // cd = 00
wire row01 = ~c & d;   // cd = 01
wire row11 = c & d;    // cd = 11
wire row10 = c & ~d;    // cd = 10

// Column (ab) pattern detectors
wire col00 = ~a & ~b;  // ab = 00
wire col01 = ~a & b;   // ab = 01
wire col11 = a & b;    // ab = 11
wire col10 = a & ~b;    // ab = 10

// Output construction through hierarchical combination
assign out = (row00 & (~col11)) |        // All columns except 11 when row=00
             (row01 & (col00 | col10)) | // Columns 00 and 10 when row=01
             (row11 & (~col00)) |        // All columns except 00 when row=11
             (row10 & (col00 | col01));   // Columns 00 and 01 when row=10

endmodule