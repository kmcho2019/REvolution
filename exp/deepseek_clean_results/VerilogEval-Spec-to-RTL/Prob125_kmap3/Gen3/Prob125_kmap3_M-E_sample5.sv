module TopModule(
    input a,
    input b,
    input c,
    input d,
    output out
);
    // Decode ab combinations
    wire ab01 = ~a & b;
    wire ab00 = ~a & ~b;
    wire ab10 = a & ~b;
    wire ab11 = a & b;

    // Output logic for each cd case
    wire case00 = ab10 | ab11;  // cd=00: 1 when ab=10 or 11
    wire case01 = 1'b0;         // cd=01: always 0 (treat don't-cares as 0)
    wire case1x = ~ab01;        // cd=1x: 0 only when ab=01, else 1

    // Final output selection
    assign out = (~c & ~d) ? case00 :
                 (~c & d)  ? case01 :
                 case1x;
endmodule