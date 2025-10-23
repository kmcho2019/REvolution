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

    assign w = {a[4:1], a[0], b[4]};
    assign x = {b[3:0], c[4:3], c[2:1], c[0], d[4]};
    assign y = {d[3:0], e[4:3], e[2:1], e[0], f[4]};
    assign z = {f[3:0], 2'b11};

endmodule