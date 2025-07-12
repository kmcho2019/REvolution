// Define the SplitModule for splitting the output vector
module SplitModule(
    input  logic [31:0] input_vector,
    output logic [7:0] w,
    output logic [7:0] x,
    output logic [7:0] y,
    output logic [7:0] z
);

    // Direct bit assignment for efficiency
    assign w = input_vector[31:24];
    assign x = input_vector[23:16];
    assign y = input_vector[15:8];
    assign z = input_vector[7:0];

endmodule

// Define the TopModule as the top-level module
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

    // Internal signal for the concatenated and appended vector
    logic [31:0] appended_vector;

    // Concatenate the input vectors and append two '1' bits
    assign appended_vector = {a, b, c, d, e, f, 2'b11};

    // Instantiate the SplitModule
    SplitModule split_module(
        .input_vector(appended_vector),
        .w(w),
        .x(x),
        .y(y),
        .z(z)
    );

endmodule