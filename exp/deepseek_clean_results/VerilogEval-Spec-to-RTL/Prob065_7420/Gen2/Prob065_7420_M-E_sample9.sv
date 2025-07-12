module TopModule (
    input p1a,
    input p1b,
    input p1c,
    input p1d,
    input p2a,
    input p2b,
    input p2c,
    input p2d,
    output p1y,
    output p2y
);
    // First NAND gate implemented as LUT
    wire [3:0] p1_inputs = {p1a, p1b, p1c, p1d};
    assign p1y = (p1_inputs == 4'b1111) ? 1'b0 : 1'b1;

    // Second NAND gate implemented as LUT
    wire [3:0] p2_inputs = {p2a, p2b, p2c, p2d};
    assign p2y = (p2_inputs == 4'b1111) ? 1'b0 : 1'b1;

endmodule