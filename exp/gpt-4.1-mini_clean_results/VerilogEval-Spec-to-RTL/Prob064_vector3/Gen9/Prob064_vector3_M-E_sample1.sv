module TopModule(
    input  [4:0] a,
    input  [4:0] b,
    input  [4:0] c,
    input  [4:0] d,
    input  [4:0] e,
    input  [4:0] f,
    output [7:0] w,
    output [7:0] x,
    output [7:0] y,
    output [7:0] z
);

    // Assign outputs by directly combining inputs and appended bits in different groups

    // w: a[4:0] + upper 3 bits of b
    assign w = {a, b[4:2]};

    // x: lower 2 bits of b + c[4:0] + highest bit of d
    assign x = {b[1:0], c, d[4]};

    // y: remaining bits of d + e[4:0]
    // d has 5 bits total, used 1 bit in x, so bits [3:0] go here
    assign y = {d[3:0], e};

    // z: f[4:0] + appended two '1's in LSBs + pad one zero bit to fill 8 bits
    assign z = {f, 2'b11, 1'b0};

endmodule