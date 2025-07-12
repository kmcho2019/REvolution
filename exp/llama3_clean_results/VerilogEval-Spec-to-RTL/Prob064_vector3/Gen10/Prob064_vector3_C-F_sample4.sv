module ConcatModule(
    input  logic [4:0] a,
    input  logic [4:0] b,
    input  logic [4:0] c,
    input  logic [4:0] d,
    input  logic [4:0] e,
    input  logic [4:0] f,
    output logic [29:0] concatenated_vector
);

    wire [9:0] ab;
    wire [9:0] cd;
    wire [9:0] ef;

    assign ab = {a, b};
    assign cd = {c, d};
    assign ef = {e, f};

    assign concatenated_vector = {ab, cd, ef};

endmodule

module AppendModule(
    input  logic [29:0] input_vector,
    output logic [31:0] output_vector
);

    assign output_vector = {input_vector, 2'b11};

endmodule

module SplitModule(
    input  logic [31:0] input_vector,
    output logic [7:0] w,
    output logic [7:0] x,
    output logic [7:0] y,
    output logic [7:0] z
);

    assign w = {input_vector[31], input_vector[30], input_vector[29], input_vector[28], input_vector[27], input_vector[26], input_vector[25], input_vector[24]};
    assign x = {input_vector[23], input_vector[22], input_vector[21], input_vector[20], input_vector[19], input_vector[18], input_vector[17], input_vector[16]};
    assign y = {input_vector[15], input_vector[14], input_vector[13], input_vector[12], input_vector[11], input_vector[10], input_vector[9], input_vector[8]};
    assign z = {input_vector[7], input_vector[6], input_vector[5], input_vector[4], input_vector[3], input_vector[2], input_vector[1], input_vector[0]};

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
    logic [31:0] appended_vector;

    ConcatModule concat_module(
       .a(a),
       .b(b),
       .c(c),
       .d(d),
       .e(e),
       .f(f),
       .concatenated_vector(concatenated_vector)
    );

    AppendModule append_module(
       .input_vector(concatenated_vector),
       .output_vector(appended_vector)
    );

    SplitModule split_module(
       .input_vector(appended_vector),
       .w(w),
       .x(x),
       .y(y),
       .z(z)
    );

endmodule