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

    assign w = {a[4:1], b[4:3]};
    assign x = {b[2:0], c[4:2]};
    assign y = {c[1:0], d[4:1], e[4:3]};
    assign z = {e[2:0], f[4:1], 2'b11};

endmodule