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
    // w: bits from a[4:0] and b[4:2] (3 bits)
    assign w = {a, b[4:2]};

    // x: bits from b[1:0], c[4:0], and d[4] (1 bit)
    assign x = {b[1:0], c, d[4]};

    // y: bits from d[3:0], e[4:1]
    assign y = {d[3:0], e[4:1]};

    // z: bits from e[0], f[4:0], then append two '1' bits at LSB
    assign z = {e[0], f, 2'b11};

endmodule