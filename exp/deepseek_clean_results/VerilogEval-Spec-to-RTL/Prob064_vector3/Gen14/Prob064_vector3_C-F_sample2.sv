module TopModule (
    input [4:0] a, b, c, d, e, f,
    output [7:0] w, x, y, z
);

    // Direct assignment with explicit bit-widths and padding
    assign {w, x, y, z} = {
        a[4:0], b[4:0], c[4:0], d[4:0], e[4:0], f[4:0],  // 30 bits of inputs
        2'b11                                             // 2 bits of padding
    };

endmodule