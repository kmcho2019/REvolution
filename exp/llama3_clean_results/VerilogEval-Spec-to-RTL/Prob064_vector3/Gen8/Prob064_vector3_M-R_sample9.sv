module SplitModule(
    input  logic [31:0] input_vector,
    output logic [7:0] w,
    output logic [7:0] x,
    output logic [7:0] y,
    output logic [7:0] z
);

    assign w = input_vector[31:24];
    assign x = input_vector[23:16];
    assign y = input_vector[15:8];
    assign z = input_vector[7:0];

endmodule

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

    logic [31:0] concatenated_and_appended;

    assign concatenated_and_appended = {a, b, c, d, e, f, 2'b11};

    SplitModule split_module(
        .input_vector(concatenated_and_appended),
        .w(w),
        .x(x),
        .y(y),
        .z(z)
    );

endmodule