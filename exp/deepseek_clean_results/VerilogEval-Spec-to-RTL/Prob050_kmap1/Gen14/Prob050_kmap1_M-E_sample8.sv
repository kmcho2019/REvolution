module TopModule (
    input a,
    input b,
    input c,
    output out
);
    // Decode all possible input patterns
    wire pattern_000 = ~a & ~b & ~c;
    wire pattern_001 = ~a & ~b &  c;
    wire pattern_010 = ~a &  b & ~c;
    wire pattern_011 = ~a &  b &  c;
    wire pattern_100 =  a & ~b & ~c;
    wire pattern_101 =  a & ~b &  c;
    wire pattern_110 =  a &  b & ~c;
    wire pattern_111 =  a &  b &  c;

    // Output is 1 for all patterns except 000
    assign out = pattern_001 | pattern_010 | pattern_011 | 
                 pattern_100 | pattern_101 | pattern_110 | 
                 pattern_111;
endmodule