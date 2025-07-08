module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out
);

// K-map output values (cd rows, ab columns):
//       00  01  11  10  (ab)
// 00 |  1 | 1 | 0 | 1 |
// 01 |  1 | 0 | 0 | 1 |
// 11 |  0 | 1 | 1 | 1 |
// 10 |  1 | 1 | 0 | 0 |
// cd

// Define intermediate wires for each cell where output=1
wire m_00_00 = ~a & ~b & ~c & ~d;  // ab=00 cd=00
wire m_01_00 = ~a &  b & ~c & ~d;  // ab=01 cd=00
wire m_10_00 =  a & ~b & ~c & ~d;  // ab=10 cd=00

wire m_00_01 = ~a & ~b & ~c &  d;  // ab=00 cd=01
wire m_10_01 =  a & ~b & ~c &  d;  // ab=10 cd=01

wire m_01_11 = ~a &  b &  c &  d;  // ab=01 cd=11
wire m_11_11 =  a &  b &  c &  d;  // ab=11 cd=11
wire m_10_11 =  a & ~b &  c &  d;  // ab=10 cd=11

wire m_00_10 = ~a & ~b &  c & ~d;  // ab=00 cd=10
wire m_01_10 = ~a &  b &  c & ~d;  // ab=01 cd=10

wire m_01_01 = ~a &  b & ~c &  d;  // ab=01 cd=01 (output=0) skip
wire m_11_01 =  a &  b & ~c &  d;  // ab=11 cd=01 (output=0) skip
wire m_11_10 =  a &  b &  c & ~d;  // ab=11 cd=10 (output=0) skip
wire m_10_10 =  a & ~b &  c & ~d;  // ab=10 cd=10 (output=0) skip
wire m_11_00 =  a &  b & ~c & ~d;  // ab=11 cd=00 (output=0) skip
wire m_00_11 = ~a & ~b &  c &  d;  // ab=00 cd=11 (output=0) skip

assign out = m_00_00 | m_01_00 | m_10_00 |
             m_00_01 | m_10_01 |
             m_01_11 | m_11_11 | m_10_11 |
             m_00_10 | m_01_10;

endmodule