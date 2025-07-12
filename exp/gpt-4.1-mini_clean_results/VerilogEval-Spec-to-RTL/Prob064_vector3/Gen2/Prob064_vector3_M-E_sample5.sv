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

    // Assign bits to w: a[4:0], b[2:0]
    assign w = {a, b[2:0]};

    // Assign bits to x: b[4:3], c[4:0], d[0]
    assign x = {b[4:3], c, d[0]};

    // Assign bits to y: d[4:1], e[3:0]
    assign y = {d[4:1], e[3:0]};

    // Assign bits to z: e[4], f[4:0], two 1 bits
    assign z = {e[4], f, 2'b11};

endmodule