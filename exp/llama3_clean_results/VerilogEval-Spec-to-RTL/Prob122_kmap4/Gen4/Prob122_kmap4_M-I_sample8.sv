module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

    wire ab_01_or_10; // Condition for ab = 01 or 10
    wire ab_00_or_11; // Condition for ab = 00 or 11

    assign ab_01_or_10 = (a == 0 && b == 1) || (a == 1 && b == 0);
    assign ab_00_or_11 = (a == 0 && b == 0) || (a == 1 && b == 1);

    assign out = (c == 0 && d == 0 && ab_01_or_10) ||
                 (c == 0 && d == 1 && ab_00_or_11) ||
                 (c == 1 && d == 1 && ab_01_or_10) ||
                 (c == 1 && d == 0 && ab_00_or_11);

endmodule