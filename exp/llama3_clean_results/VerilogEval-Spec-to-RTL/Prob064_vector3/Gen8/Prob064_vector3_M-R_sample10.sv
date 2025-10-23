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

    wire [29:0] concatenated_vector;
    assign concatenated_vector = {a, b, c, d, e, f};
    assign w = concatenated_vector[29:22];
    assign x = concatenated_vector[21:14];
    assign y = concatenated_vector[13:6];
    assign z = {concatenated_vector[5:0], 2'b11};

endmodule