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

    // Intermediate wires for p1y first 3-input AND: (p1a AND p1b AND p1c)
    wire and_p1_1_stage1;
    wire and_p1_1;

    // Intermediate wires for p1y second 3-input AND: (p1d AND p1e AND p1f)
    wire and_p1_2_stage1;
    wire and_p1_2;

    // Wires for p2y AND gates
    wire and_p2_1;
    wire and_p2_2;

    // First 3-input AND for p1y: p1a AND p1b AND p1c
    and and1_stage1 (and_p1_1_stage1, p1a, p1b);
    and and1_stage2 (and_p1_1, and_p1_1_stage1, p1c);

    // Second 3-input AND for p1y: p1d AND p1e AND p1f
    and and2_stage1 (and_p1_2_stage1, p1d, p1e);
    and and2_stage2 (and_p1_2, and_p1_2_stage1, p1f);

    // OR gate for p1y: OR of two 3-input AND gate outputs
    or or_p1 (p1y, and_p1_1, and_p1_2);

    // 2-input AND gates for p2y
    and and_p2_a (and_p2_1, p2a, p2b);
    and and_p2_b (and_p2_2, p2c, p2d);

    // OR gate for p2y: OR of two 2-input AND gate outputs
    or or_p2 (p2y, and_p2_1, and_p2_2);

endmodule