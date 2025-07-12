module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out_sop,
    output out_pos
);

    // Input bits as a 4-bit number N = {a,b,c,d}, with 'a' as MSB and 'd' as LSB
    wire na = ~a;
    wire nb = ~b;
    wire nc = ~c;
    wire nd = ~d;

    // Minimal Sum-of-Products (SOP) for out_sop = 1 when N = 2,7,15:
    // 2  = 0 0 1 0 -> ~a & ~b & c & ~d
    // 7  = 0 1 1 1 -> ~a &  b & c &  d
    // 15 = 1 1 1 1 ->  a &  b & c &  d
    assign out_sop = (na & nb &  c & nd) | (na &  b &  c &  d) | ( a &  b &  c &  d);

    // Minimal Product-of-Sums (POS) for out_pos = 0 when N in zeros list:
    // POS = (a + b + d) & (a + ~b + c) & (~a + b + ~c + ~d)
    assign out_pos = (a | b | d) & (a | nb | c) & (na | b | nc | nd);

endmodule