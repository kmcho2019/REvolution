module TopModule (
    input [4:0] a,
    input [4:0] b,
    input [4:0] c,
    input [4:0] d,
    input [4:0] e,
    input [4:0] f,
    output [7:0] w,
    output [7:0] x,
    output [7:0] y,
    output [7:0] z
);

    // Create interleaved 30-bit pattern: a[0]b[0]c[0]d[0]e[0]f[0]a[1]b[1]...
    wire [29:0] interleaved = {
        a[0], b[0], c[0], d[0], e[0], f[0],
        a[1], b[1], c[1], d[1], e[1], f[1],
        a[2], b[2], c[2], d[2], e[2], f[2],
        a[3], b[3], c[3], d[3], e[3], f[3],
        a[4], b[4], c[4], d[4], e[4], f[4]
    };

    // Pad with two 1's and assign to outputs
    assign {w, x, y, z} = {interleaved, 2'b11};

endmodule