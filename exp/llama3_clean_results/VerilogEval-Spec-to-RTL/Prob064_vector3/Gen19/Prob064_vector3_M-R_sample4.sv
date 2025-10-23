module TopModule(
    input  logic [4:0] a,
    input  logic [4:0] b,
    input  logic [4:0] c,
    input  logic [4:0] d,
    input  logic [4:0] e,
    input  logic [4:0] f,
    output logic [7:0] w,
    output logic [7:0] x,
    output logic [7:0] y,
    output logic [7:0] z
);

    assign w = {a[4:3], b[4:3], c[4:3], d[4:3], e[4:3], f[4:3], 2'b00};
    assign x = {a[2:0], b[2:0], c[2:0], d[2:0], e[2:0], f[2:0], 2'b00};
    assign y = {a[3:1], b[3:1], c[3:1], d[3:1], e[3:1], f[3:1], 2'b00};
    assign z = {a, b, c, d, e, f}[7:0] | 2;

endmodule