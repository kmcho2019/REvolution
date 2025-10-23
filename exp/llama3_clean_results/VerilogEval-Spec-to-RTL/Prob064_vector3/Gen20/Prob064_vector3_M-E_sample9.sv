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

    assign w = {a[4:3], b[4:3], c[4:3], d[4:3], e[4:3], f[4:3], 2'b11};
    assign x = {a[2:0], b[4:3], c[2:0], d[4:3], e[2:0], f[4:3]};
    assign y = {b[2:0], c[4:3], d[2:0], e[4:3], f[2:0], a[4:3], 2'b00};
    assign z = {c[2:0], d[2:0], e[2:0], f[2:0], a[2:0], b[2:0], 2'b11};

    // Corrected version:
    logic [29:0] concatenated_vector;
    assign concatenated_vector = {a, b, c, d, e, f};
    assign w = concatenated_vector[29:22];
    assign x = concatenated_vector[21:14];
    assign y = concatenated_vector[13:6];
    assign z = {concatenated_vector[5:0], 2'b11};

endmodule