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

    assign w = {a[4:1], b[4:2]};
    assign x = {b[1:0], c[4:1], d[4:3]};
    assign y = {d[2:0], e[4:1], f[4:3]};
    assign z = {f[2:0], 2'b11};

endmodule