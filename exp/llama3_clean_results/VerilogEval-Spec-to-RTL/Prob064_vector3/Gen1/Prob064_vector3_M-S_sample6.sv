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

assign w = {a[4:1], b[4:3], c[4], 4'b0};
assign x = {b[2:0], c[3:0], d[4:3]};
assign y = {d[2:0], e[4:1], f[4]};
assign z = {e[0], f[3:0], 2'b11};

endmodule