module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out_sop,
    output out_pos
);

    // Input bits as a 4-bit number N = {a,b,c,d} with 'a' as MSB and 'd' as LSB
    wire na = ~a;
    wire nb = ~b;
    wire nc = ~c;
    wire nd = ~d;

    // Minimal Sum-of-Products (SOP) for out_sop = 1 when N = 2,7,15:
    // 2  = 0 0 1 0 -> ~a & ~b &  c & ~d
    // 7  = 0 1 1 1 -> ~a &  b &  c &  d
    // 15 = 1 1 1 1 ->  a &  b &  c &  d
    assign out_sop = (na & nb &  c & nd)
                   | (na &  b &  c &  d)
                   | ( a &  b &  c &  d);

    // Product-of-Sums (POS) explicitly from all zeros' maxterms:
    // Zero decimal inputs and their maxterms:
    // 0  = 0000 => (a + b + c + d)
    // 1  = 0001 => (a + b + c + ~d)
    // 4  = 0100 => (a + ~b + c + d)
    // 5  = 0101 => (a + ~b + c + ~d)
    // 6  = 0110 => (a + ~b + ~c + d)
    // 9  = 1001 => (~a + b + c + ~d)
    // 10 = 1010 => (~a + b + ~c + d)
    // 13 = 1101 => (~a + ~b + c + ~d)
    // 14 = 1110 => (~a + ~b + ~c + d)
    assign out_pos =
        ( a |  b |  c |  d)  // M0
      & ( a |  b |  c | nd)  // M1
      & ( a | nb |  c |  d)  // M4
      & ( a | nb |  c | nd)  // M5
      & ( a | nb | nc |  d)  // M6
      & (na |  b |  c | nd)  // M9
      & (na |  b | nc |  d)  // M10
      & (na | nb |  c | nd)  // M13
      & (na | nb | nc |  d); // M14

endmodule