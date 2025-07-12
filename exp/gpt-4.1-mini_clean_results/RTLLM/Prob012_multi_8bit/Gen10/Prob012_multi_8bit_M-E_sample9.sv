module multi_8bit (
    input  wire [7:0] A,
    input  wire [7:0] B,
    output wire [15:0] product
);

    // Internal wires for the shifted multiplicand at each stage
    wire [15:0] shifted_A [0:8];
    // Accumulators after each stage
    wire [15:0] accum [0:8];

    // Initialize shifted_A[0] as zero-extended A (no shift)
    assign shifted_A[0] = {8'b0, A}; // Extend A to 16 bits

    // Initialize accumulator to zero
    assign accum[0] = 16'b0;

    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : multiply_stages
            // Shift the multiplicand left by 1 bit per stage
            assign shifted_A[i+1] = shifted_A[i] << 1;

            // If B[i] == 1, add shifted_A[i] to previous accumulator
            // else pass accumulator unchanged
            assign accum[i+1] = B[i] ? (accum[i] + shifted_A[i]) : accum[i];
        end
    endgenerate

    // Final product is accumulator after processing all bits of B
    assign product = accum[8];

endmodule