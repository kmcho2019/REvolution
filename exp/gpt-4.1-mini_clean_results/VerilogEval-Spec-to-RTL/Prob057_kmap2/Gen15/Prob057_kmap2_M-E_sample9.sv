module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

    wire sel0, sel1, sel2, sel3;
    wire [1:0] sel;

    assign sel = {c, d};

    // For cd = 00: output is 1 when (ab=00,01,10) except 11=0
    // So output = ~(a & b)
    assign sel0 = ~(a & b);

    // For cd = 01: output=1 for ab=00,10; output=0 for ab=01,11
    // So output = ~b & ~a | ~b & a = ~b
    assign sel1 = ~b;

    // For cd = 11: output=1 for ab=01,11,10; output=0 for ab=00
    // So output = (b) | (a & b)
    // Simplify: output = b | (a & b) = b
    assign sel2 = b;

    // For cd = 10: output=1 for ab=00,01; output=0 for ab=11,10
    // So output = ~a & ~b | ~a & b = ~a
    assign sel3 = ~a;

    // Multiplexer selects based on c,d
    assign out = (sel == 2'b00) ? sel0 :
                 (sel == 2'b01) ? sel1 :
                 (sel == 2'b11) ? sel2 :
                 /* sel == 2'b10 */ sel3;

endmodule