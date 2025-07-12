module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

// Decode select lines for mux (ab)
wire sel0 = ~a & ~b;  // ab=00
wire sel1 = ~a &  b;  // ab=01
wire sel2 =  a &  b;  // ab=11
wire sel3 =  a & ~b;  // ab=10

// For ab=00: c d -> output from K-map row cd=00:1,01:1,11:0,10:1
// Expression: out = ~c & ~d | ~c & d | c & ~d = ~c | (c & ~d)
wire out0 = (~c) | (c & ~d);

// For ab=01: c d -> outputs: 00:1,01:0,11:0,10:1
// Expression: out = ~c & ~d | c & ~d = ~d & (~c | c) = ~d
wire out1 = ~d;

// For ab=11: c d -> outputs: 00:0,01:1,11:1,10:1
// Expression: out = (~c & d) | (c & d) | (c & ~d) = d | (c & ~d)
wire out2 = d | (c & ~d);

// For ab=10: c d -> outputs: 00:1,01:1,11:0,10:0
// Expression: out = ~c & ~d | ~c & d = ~c
wire out3 = ~c;

// Mux outputs based on (a,b)
assign out = (sel0 & out0) |
             (sel1 & out1) |
             (sel2 & out2) |
             (sel3 & out3);

endmodule