module TopModule (
    input  a, b, c, d,
    output out_sop,
    output out_pos
);

    // Minimal Sum of Products (a'b'cd' + bcd + a'd)
    assign out_sop = (~a & ~b & c & ~d) |  // 2 (0010)
                     (b & c & d) |         // 7 (0111), 15 (1111)
                     (a & d);              // Also covers some don't-cares

    // Minimal Product of Sums (a+b)(b'+c)(b'+d')
    assign out_pos = (a | b) &             // Covers maxterms 0,1,4,5,8,9
                     (~b | c) &            // Covers maxterms 6,10,14
                     (~b | ~d);            // Covers maxterms 13

endmodule