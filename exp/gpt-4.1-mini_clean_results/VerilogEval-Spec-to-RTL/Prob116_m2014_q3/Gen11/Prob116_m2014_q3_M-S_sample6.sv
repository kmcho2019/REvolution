module TopModule(
    input  [3:0] x,
    output      f
);

    // For clarity, name bits as per Karnaugh map notation:
    // Rows: x3 x2, Columns: x1 x0
    wire x3 = x[3];
    wire x2 = x[2];
    wire x1 = x[1];
    wire x0 = x[0];

    // From Karnaugh map analysis:
    // minterms for f=1 (cells with 1):
    // Row Col - f
    // 01 11 (x3x2=01, x1x0=11) => x3=0,x2=1,x1=1,x0=1
    // 11 00 (x3x2=11, x1x0=00)
    // 11 01
    // 10 00
    // 10 01
    // 01 11 (already counted)
    // 11 01 (already counted)
    // 10 00 (already counted)
    // 10 01 (already counted)

    // Using Karnaugh grouping and don't cares, one minimal SOP expression is:
    // f = (~x3 & x2 & x1 & x0) // cell (01,11)
    //   + (x3 & x2 & ~x1)     // covers (11,00), (11,01)
    //   + (x3 & ~x2 & ~x1)    // covers (10,00), (10,01)

    assign f = (~x3 & x2 & x1 & x0) | (x3 & x2 & ~x1) | (x3 & ~x2 & ~x1);

endmodule