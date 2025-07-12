module sub_64bit (
    input   [63:0] A,
    input   [63:0] B,
    output  [63:0] result,
    output         overflow
);

    // Define the number of bits per slice
    parameter BITS_PER_SLICE = 8;

    // Calculate the number of slices
    parameter NUM_SLICES = 64 / BITS_PER_SLICE;

    // Define the wire types for the internal signals
    wire [NUM_SLICES-1:0] slice_carry;
    wire [NUM_SLICES-1:0] slice_overflow;
    wire [63:0] temp_result;

    // Perform bit-sliced subtraction
    genvar i;
    generate
        for (i = 0; i < NUM_SLICES; i++) begin
            // Calculate the bit offset for this slice
            wire [BITS_PER_SLICE-1:0] slice_A = A[(i*BITS_PER_SLICE)+:BITS_PER_SLICE];
            wire [BITS_PER_SLICE-1:0] slice_B = B[(i*BITS_PER_SLICE)+:BITS_PER_SLICE];

            // Perform subtraction for this slice
            wire [BITS_PER_SLICE-1:0] slice_result;
            assign slice_result = slice_A - slice_B;

            // Detect overflow for this slice
            assign slice_overflow[i] = (slice_A[BITS_PER_SLICE-1] == 1'b1 && slice_B[BITS_PER_SLICE-1] == 1'b0 && slice_result[BITS_PER_SLICE-1] == 1'b1) ||
                                      (slice_A[BITS_PER_SLICE-1] == 1'b0 && slice_B[BITS_PER_SLICE-1] == 1'b1 && slice_result[BITS_PER_SLICE-1] == 1'b0);

            // Propagate carry to the next slice
            assign slice_carry[i] = (slice_A + (~slice_B + 1))[BITS_PER_SLICE];

            // Concatenate the slice result to the temp result
            assign temp_result[(i*BITS_PER_SLICE)+:BITS_PER_SLICE] = slice_result;
        end
    endgenerate

    // Detect overall overflow
    assign overflow = |slice_overflow;

    // Assign the final result
    assign result = temp_result;

endmodule