module TopModule(a, b, c, d, out);
    input a, b, c, d;
    output out;

    // The logic derived from the Karnaugh map
    // We look for minterms (product terms) where 'out' is 1
    assign out = (a & b & ~c & ~d) |  // ab 00
                 (~a & b & ~c & ~d) |  // 0b 00
                 (a & b & ~c & d)  |  // ab 01
                 (~a & b & ~c & d)  |  // 0b 01
                 (a & b & c & d)    |  // ab 11
                 (~a & b & c & d)   |  // 0b 11
                 (~a & ~b & c & d)  |  // 00 11
                 (a & ~b & ~c & ~d) |  // a0 00
                 (~a & ~b & ~c & ~d) |  // 00 00
                 (a & ~b & c & ~d)  |  // a0 10
                 (a & ~b & ~c & d);    // a0 01

endmodule