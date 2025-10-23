module TopModule(
    input a,
    input b,
    input c,
    input d,
    output out
);

assign out = (
    // cd = 00, ab = 00 (minterm 0000)
    (!c && !d && !a && !b) ||
    // cd = 00, ab = 01 (minterm 0001)
    (!c && !d && !a && b) ||
    // cd = 00, ab = 10 (minterm 0010)
    (!c && !d && a && !b) ||
    // cd = 01, ab = 00 (minterm 0100)
    (!c && d && !a && !b) ||
    // cd = 01, ab = 10 (minterm 0110)
    (!c && d && a && !b) ||
    // cd = 11, ab = 01 (minterm 1101)
    (c && d && !a && b) ||
    // cd = 11, ab = 10 (minterm 1110)
    (c && d && a && !b) ||
    // cd = 10, ab = 00 (minterm 1000)
    (c && !d && !a && !b) ||
    // cd = 10, ab = 01 (minterm 1001)
    (c && !d && !a && b)
);

endmodule