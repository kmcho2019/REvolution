module fixed_point_subtractor #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16,  // Total number of bits
    parameter SLICE_WIDTH = 4  // Slice width for bit-slicing
)(
    input signed [N-1:0] a,
    input signed [N-1:0] b,
    output reg signed [N-1:0] c
);

// Calculate the number of slices
localparam NUM_SLICES = N / SLICE_WIDTH;

// Define the ALU for subtraction
module alu_sub #(
    parameter WIDTH = SLICE_WIDTH
)(
    input signed [WIDTH-1:0] a,
    input signed [WIDTH-1:0] b,
    output reg signed [WIDTH-1:0] c
);
    always @(*) begin
        c = a - b;
    end
endmodule

// Define the bit-sliced subtractor
module bit_sliced_subtractor #(
    parameter NUM_SLICES = NUM_SLICES,
    parameter SLICE_WIDTH = SLICE_WIDTH
)(
    input signed [NUM_SLICES*SLICE_WIDTH-1:0] a,
    input signed [NUM_SLICES*SLICE_WIDTH-1:0] b,
    output reg signed [NUM_SLICES*SLICE_WIDTH-1:0] c
);
    reg signed [SLICE_WIDTH-1:0] slice_a [NUM_SLICES-1:0];
    reg signed [SLICE_WIDTH-1:0] slice_b [NUM_SLICES-1:0];
    reg signed [SLICE_WIDTH-1:0] slice_c [NUM_SLICES-1:0];

    // Slice the input operands
    always @(*) begin
        for (int i = 0; i < NUM_SLICES; i++) begin
            slice_a[i] = a[(i+1)*SLICE_WIDTH-1:i*SLICE_WIDTH];
            slice_b[i] = b[(i+1)*SLICE_WIDTH-1:i*SLICE_WIDTH];
        end
    end

    // Perform subtraction on each slice
    alu_sub u_alu_sub [NUM_SLICES-1:0] (
       .a(slice_a),
       .b(slice_b),
       .c(slice_c)
    );

    // Combine the slice results
    always @(*) begin
        c = {<<{slice_c}};
    end
endmodule

// Instantiate the bit-sliced subtractor
bit_sliced_subtractor u_bit_sliced_subtractor (
   .a(a),
   .b(b),
   .c(c)
);

endmodule