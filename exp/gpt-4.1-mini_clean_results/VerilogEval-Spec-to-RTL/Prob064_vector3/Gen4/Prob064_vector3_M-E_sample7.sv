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
    // Assign bits from inputs to outputs in order:
    // Total bits = 30 bits from inputs + 2 bits '1' in LSBs of z

    // w = bits [31:24] = a[4:0], b[2:0] (5 + 3 bits)
    assign w = { a[4:0], b[2:0] };

    // x = bits [23:16] = b[4:3], c[4:0], d[0]
    assign x = { b[4:3], c[4:0], d[0] };

    // y = bits [15:8] = d[4:1], e[3:0]
    assign y = { d[4:1], e[3:0] };

    // z = bits [7:0] = e[4], f[4:0], two 1's at LSB
    assign z = { e[4], f[4:0], 2'b11 };

endmodule