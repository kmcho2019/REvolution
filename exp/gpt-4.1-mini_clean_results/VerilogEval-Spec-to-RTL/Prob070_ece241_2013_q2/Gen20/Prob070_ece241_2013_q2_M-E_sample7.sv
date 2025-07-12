module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out_sop,
    output out_pos
);

    // Helper function to check equality to a 4-bit constant
    wire eq_2, eq_7, eq_15;
    wire eq_0, eq_1, eq_4, eq_5, eq_6, eq_9, eq_10, eq_13, eq_14;

    // Check equality to decimal 2 (0010)
    assign eq_2  = (~a) & (~b) & c & (~d);
    // Check equality to decimal 7 (0111)
    assign eq_7  = (~a) & b & c & d;
    // Check equality to decimal 15 (1111)
    assign eq_15 = a & b & c & d;

    // For zeros: check equality and OR all
    assign eq_0  = (~a) & (~b) & (~c) & (~d);
    assign eq_1  = (~a) & (~b) & (~c) & d;
    assign eq_4  = (~a) & b & (~c) & (~d);
    assign eq_5  = (~a) & b & (~c) & d;
    assign eq_6  = (~a) & b & c & (~d);
    assign eq_9  = a & (~b) & (~c) & d;
    assign eq_10 = a & (~b) & c & (~d);
    assign eq_13 = a & b & (~c) & d;
    assign eq_14 = a & b & c & (~d);

    // out_sop is 1 if input equals 2,7, or 15
    assign out_sop = eq_2 | eq_7 | eq_15;

    // out_pos is 1 when input is NOT equal to any zero values
    // So, out_pos = ~ (eq_0 | eq_1 | eq_4 | eq_5 | eq_6 | eq_9 | eq_10 | eq_13 | eq_14)
    assign out_pos = ~ (eq_0 | eq_1 | eq_4 | eq_5 | eq_6 | eq_9 | eq_10 | eq_13 | eq_14);

endmodule