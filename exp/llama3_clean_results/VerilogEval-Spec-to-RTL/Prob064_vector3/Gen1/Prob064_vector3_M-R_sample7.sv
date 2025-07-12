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

    assign w = {a[4:1], b[4], b[3], b[2], b[1], b[0], c[4]};
    assign x = {c[3:0], d[4:1], d[0], e[4:2]};
    assign y = {e[1:0], f[4:2], f[1:0], 2'b11};
    assign z = {f[0], 1'b1, 7'b0};

endmodule