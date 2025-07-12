module MultiConcatPacked #(
    parameter WIDTH = 5,
    parameter NUM_INPUTS = 6,
    parameter OUT_WIDTH = WIDTH * NUM_INPUTS
) (
    input  [NUM_INPUTS*WIDTH-1:0] in_vec,  // Flattened input: concatenation of all inputs
    output [OUT_WIDTH-1:0] out
);
    // Concatenate NUM_INPUTS 5-bit segments into a single wide output.
    // Since inputs are packed concatenation already, output equals input vector directly.
    // This module serves as a semantic wrapper for clarity and future extension.
    assign out = in_vec;
endmodule

module TopModule (
    input  [4:0] a,
    input  [4:0] b,
    input  [4:0] c,
    input  [4:0] d,
    input  [4:0] e,
    input  [4:0] f,
    output [7:0] w,
    output [7:0] x,
    output [7:0] y,
    output [7:0] z
);

    // Pack all six 5-bit inputs into a single 30-bit vector input to helper
    wire [29:0] packed_inputs = {a, b, c, d, e, f};

    // Instantiate parameterized helper module to output concatenated vector
    wire [29:0] concatenated;
    MultiConcatPacked #(.WIDTH(5), .NUM_INPUTS(6)) mc (
        .in_vec(packed_inputs),
        .out(concatenated)
    );

    // Append two LSB '1' bits to create 32-bit combined output
    wire [31:0] combined = {concatenated, 2'b11};

    // Assign four 8-bit outputs from combined vector slices
    assign w = combined[31:24];
    assign x = combined[23:16];
    assign y = combined[15:8];
    assign z = combined[7:0];

endmodule