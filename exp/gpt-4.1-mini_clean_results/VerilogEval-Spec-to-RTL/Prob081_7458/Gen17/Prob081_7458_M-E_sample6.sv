module TopModule (
    input  p1a,
    input  p1b,
    input  p1c,
    input  p1d,
    input  p1e,
    input  p1f,
    input  p2a,
    input  p2b,
    input  p2c,
    input  p2d,
    output p1y,
    output p2y
);

    wire and_p1_1_out, and_p1_2_out;
    wire and_p2_1_out, and_p2_2_out;

    // Instantiate 3-input AND gates for p1
    and and_p1_1 (and_p1_1_out, p1a, p1b, p1c);
    and and_p1_2 (and_p1_2_out, p1d, p1e, p1f);

    // Instantiate 2-input AND gates for p2
    and and_p2_1 (and_p2_1_out, p2a, p2b);
    and and_p2_2 (and_p2_2_out, p2c, p2d);

    // OR outputs of AND gates for p1y and p2y
    or or_p1y (p1y, and_p1_1_out, and_p1_2_out);
    or or_p2y (p2y, and_p2_1_out, and_p2_2_out);

endmodule