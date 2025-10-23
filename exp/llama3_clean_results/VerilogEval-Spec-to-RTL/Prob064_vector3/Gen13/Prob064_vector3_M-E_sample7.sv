module FlexibleModule #(
    parameter NUM_INPUT_VECTORS = 6,
    parameter INPUT_VECTOR_WIDTH = 5,
    parameter OUTPUT_VECTOR_WIDTH = 8
) (
    input  logic [INPUT_VECTOR_WIDTH-1:0] input_vectors [NUM_INPUT_VECTORS-1:0],
    output logic [OUTPUT_VECTOR_WIDTH-1:0] output_vectors [3:0]
);

    localparam TOTAL_INPUT_BITS = NUM_INPUT_VECTORS * INPUT_VECTOR_WIDTH;
    localparam TOTAL_OUTPUT_BITS = 4 * OUTPUT_VECTOR_WIDTH;

    logic [TOTAL_INPUT_BITS-1:0] concatenated_vector;
    logic [TOTAL_OUTPUT_BITS-1:0] output_vector;

    // Concatenate input vectors
    assign concatenated_vector = {input_vectors[NUM_INPUT_VECTORS-1:0]};

    // Append 1 bits and split into output vectors
    assign output_vector = {concatenated_vector, 2'b11};
    assign output_vectors[0] = output_vector[31:24];
    assign output_vectors[1] = output_vector[23:16];
    assign output_vectors[2] = output_vector[15:8];
    assign output_vectors[3] = output_vector[7:0];

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

    logic [4:0] input_vectors [5:0];
    logic [7:0] output_vectors [3:0];

    assign input_vectors[0] = a;
    assign input_vectors[1] = b;
    assign input_vectors[2] = c;
    assign input_vectors[3] = d;
    assign input_vectors[4] = e;
    assign input_vectors[5] = f;

    FlexibleModule #(
        .NUM_INPUT_VECTORS(6),
        .INPUT_VECTOR_WIDTH(5),
        .OUTPUT_VECTOR_WIDTH(8)
    ) flexible_module(
        .input_vectors(input_vectors),
        .output_vectors(output_vectors)
    );

    assign w = output_vectors[0];
    assign x = output_vectors[1];
    assign y = output_vectors[2];
    assign z = output_vectors[3];

endmodule