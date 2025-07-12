module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

// Since the K-map uses inputs (a,b) as columns and (c,d) as rows:
// Map the inputs directly and form product terms for each minterm that outputs '1'.

// First, decode inverted inputs to simplify product terms
wire na = ~a;
wire nb = ~b;
wire nc = ~c;
wire nd = ~d;

// Minterm for cd=00 (c=0,d=0)
// ab=00 => a=0,b=0 -> na & nb
wire m_00_00 = nc & nd & na & nb; // cell cd=00, ab=00: output=1
// ab=01 => a=0,b=1
wire m_00_01 = nc & nd & na & b;  // cell cd=00, ab=01: output=1
// ab=10 => a=1,b=0
wire m_00_10 = nc & nd & a & nb;  // cell cd=00, ab=10: output=1
// ab=11 => a=1,b=1 (output=0) skip

// Minterm for cd=01 (c=0,d=1)
wire m_01_00 = nc & d  & na & nb; // cell cd=01, ab=00: output=1
// ab=01 => output=0 skip
// ab=10 => output=1
wire m_01_10 = nc & d  & a  & nb;
// ab=11 => output=0 skip

// Minterm for cd=11 (c=1,d=1)
wire m_11_01 = c  & d  & na & b;  // cell cd=11, ab=01: output=1
wire m_11_10 = c  & d  & a  & nb; // cell cd=11, ab=10: output=1
wire m_11_11 = c  & d  & a  & b;  // cell cd=11, ab=11: output=1
// ab=00 => output=0 skip

// Minterm for cd=10 (c=1,d=0)
wire m_10_00 = c  & nd & na & nb; // cell cd=10, ab=00: output=1
wire m_10_01 = c  & nd & na & b;  // cell cd=10, ab=01: output=1
// ab=10 => output=0 skip
// ab=11 => output=0 skip

// OR all the minterms representing K-map '1's
assign out = m_00_00 | m_00_01 | m_00_10 |
             m_01_00 | m_01_10 |
             m_11_01 | m_11_10 | m_11_11 |
             m_10_00 | m_10_01;

endmodule