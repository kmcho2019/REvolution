module ConcatModule(
    input  logic [4:0] a,
    input  logic [4:0] b,
    input  logic [4:0] c,
    input  logic [4:0] d,
    input  logic [4:0] e,
    input  logic [4:0] f,
    output logic [29:0] concatenated_vector
);

    assign concatenated_vector = {a, b, c, d, e, f};

endmodule

module AppendAndSplitModule(
    input  logic [29:0] input_vector,
    output logic [7:0] w,
    output logic [7:0] x,
    output logic [7:0] y,
    output logic [7:0] z
);

    logic [31:0] appended_vector;
    assign appended_vector = {input_vector, 2'b11};
    assign w = appended_vector[31:24];
    assign x = appended_vector[23:16];
    assign y = appended_vector[15:8];
    assign z = appended_vector[7:0];

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

    logic [29:0] concatenated_vector;

    ConcatModule concat_module(
      .a(a),
      .b(b),
      .c(c),
      .d(d),
      .e(e),
      .f(f),
      .concatenated_vector(concatenated_vector)
    );

    AppendAndSplitModule append_and_split_module(
      .input_vector(concatenated_vector),
      .w(w),
      .x(x),
      .y(y),
      .z(z)
    );

endmodule