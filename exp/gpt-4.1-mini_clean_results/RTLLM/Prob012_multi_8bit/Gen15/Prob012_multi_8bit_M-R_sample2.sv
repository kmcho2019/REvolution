module multi_8bit (
    input  wire [7:0] A,
    input  wire [7:0] B,
    output wire [15:0] product
);

    // Array of partial sums, one per bit processed + initial zero
    wire [15:0] partial_sums [8:0];

    // Initial partial sum = 0
    assign partial_sums[0] = 16'b0;

    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : gen_shift_add
            // Compute shifted partial product if B[i] is set, else 0
            wire [15:0] shifted_A = B[i] ? (A << i) : 16'b0;
            // Accumulate partial sums
            assign partial_sums[i+1] = partial_sums[i] + shifted_A;
        end
    endgenerate

    // Final product is last accumulated partial sum
    assign product = partial_sums[8];

endmodule