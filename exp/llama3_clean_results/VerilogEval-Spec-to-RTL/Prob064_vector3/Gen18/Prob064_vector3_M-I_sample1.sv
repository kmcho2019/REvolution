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

    assign w = {a[4:1], b[4:3], c[4:2], 1'b0, 1'b1};
    assign x = {b[2:0], c[1:0], d[4:3], d[2:1], 1'b0};
    assign y = {d[0], e[4:3], e[2:1], f[4:3], f[2:1], 1'b0, 1'b1};
    assign z = {f[0], 1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1};

endmodule