module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out_sop,
    output out_pos
);

    // Minterms for 2,7,15
    wire m2  = (~a) & (~b) & c & (~d);
    wire m7  = (~a) & b & c & d;
    wire m15 = a & b & c & d;

    assign out_sop = m2 | m7 | m15;

    // Maxterms for POS, blocking all zeros except 2,7,15
    wire M1 = (~a) | b | (~c) | (~d);
    wire M2 = (~a) | (~b) | c | (~d);
    wire M3 = a | (~b) | (~c) | (~d);

    assign out_pos = M1 & M2 & M3;

endmodule