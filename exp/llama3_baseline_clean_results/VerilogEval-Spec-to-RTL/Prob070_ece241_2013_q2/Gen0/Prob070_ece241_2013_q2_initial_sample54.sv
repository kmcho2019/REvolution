module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out_sop,
    output out_pos
);

// Minimum Sum-of-Products (SOP) form for out_sop
assign out_sop = (!a && b && !c && !d) || // 2 (0010)
                 (!a && b && c && d) ||  // 7 (0111)
                 (a && b && c && d);     // 15 (1111)

// Minimum Product-of-Sums (POS) form for out_pos
assign out_pos = !(a && !b && !c && !d) &&  // not 0 (0000)
                 !(a && !b && !c && d) &&   // not 1 (0001)
                 !(a && b && !c && !d) &&   // not 4 (0100)
                 !(a && b && !c && d) &&    // not 5 (0101)
                 !(a && b && c && !d) &&    // not 6 (0110)
                 !(!a && b && !c && d) &&   // not 9 (1001)
                 !(!a && b && c && !d) &&   // not 10 (1010)
                 !(a && !b && c && d) &&    // not 13 (1101)
                 !(a && b && !c && d);      // not 14 (1110)

endmodule