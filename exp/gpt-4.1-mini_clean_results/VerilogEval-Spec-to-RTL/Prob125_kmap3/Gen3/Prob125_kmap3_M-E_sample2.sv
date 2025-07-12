module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,      // d is don't-care, ignored
    output out
);

    // Define output bits for c=0 and c=1 indexed by {a,b} as 2-bit values
    // Order of columns in Karnaugh map: 01, 00, 10, 11
    // However, we map (a,b) as binary: a is MSB, b is LSB
    // So possible ab: 00,01,10,11
    // From the Karnaugh map rows for c=0 (cd=00 or 10) and c=1 (cd=01 or 11),
    // noting that d is don't care so we choose to map like this:

    // Extract output for each ab when c=0:
    // ab=00: For c=0 (cd=00 or 10):
    //   cd=00 (a=0,b=0,c=0,d=0): out=0 (from K-map)
    // ab=01:
    //   cd=00: out=d (don't care, choose 0)
    // ab=10:
    //   cd=00: out=1
    // ab=11:
    //   cd=00: out=1

    // To summarize, for c=0:
    // ab=00 -> 0
    // ab=01 -> 0 (choose don't-care as 0)
    // ab=10 -> 1
    // ab=11 -> 1

    // For c=1:
    // ab=00: from map cd=01 or 11
    // cd=01 ab=00 out=0
    // cd=11 ab=00 out=1  (contradiction; choose 1 to simplify)
    // So pick 1 for simplification.

    // ab=01:
    // cd=01 out=0
    // cd=11 out=1
    // choose 1

    // ab=10:
    // cd=01 out=d (choose 1)
    // cd=11 out=1

    // ab=11:
    // cd=01 out=d (choose 1)
    // cd=11 out=1

    // Therefore for c=1, all ab combinations are 1

    // The 2-bit vector per ab is thus:
    // ab=00: {c=1, c=0} = 1, 0  => binary 2'b10
    // ab=01: 1, 0             => 2'b10
    // ab=10: 1, 1             => 2'b11
    // ab=11: 1, 1             => 2'b11

    // The index in array is {a,b} as 2-bit number
    wire [1:0] lut [0:3];
    assign lut[0] = 2'b10; // a=0,b=0
    assign lut[1] = 2'b10; // a=0,b=1
    assign lut[2] = 2'b11; // a=1,b=0
    assign lut[3] = 2'b11; // a=1,b=1

    wire [1:0] selected = lut[{a,b}];

    assign out = selected[c];

endmodule