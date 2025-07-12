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

    assign w = {a[4], a[3], a[2], a[1], a[0], b[4], b[3], b[2]};
    assign x = {b[1], b[0], c[4], c[3], c[2], c[1], c[0], d[4]};
    assign y = {d[3], d[2], d[1], d[0], e[4], e[3], e[2], e[1]};
    assign z = {e[0], f[4], f[3], f[2], f[1], f[0], 1'b1, 1'b1};

endmodule