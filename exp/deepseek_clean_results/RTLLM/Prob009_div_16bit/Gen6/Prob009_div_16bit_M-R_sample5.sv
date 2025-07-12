module div_16bit (
    input [15:0] A,
    input [7:0] B,
    output [15:0] result,
    output [15:0] odd
);

    // Zero-extended divisor
    wire [15:0] b_ext = {8'b0, B};

    // Intermediate remainders and quotient bits
    wire [15:0] rem [0:16];
    wire [15:0] quot;

    // Initialize remainder
    assign rem[0] = 16'b0;

    // Unrolled division steps
    genvar i;
    generate
        for (i = 15; i >= 0; i = i - 1) begin : div_step
            // Current remainder with next bit from dividend
            wire [15:0] rem_shift = {rem[15-i][14:0], A[i]};
            
            // Comparison and subtraction
            wire rem_ge = rem_shift >= b_ext;
            assign rem[16-i] = rem_ge ? (rem_shift - b_ext) : rem_shift;
            assign quot[i] = rem_ge;
        end
    endgenerate

    // Final outputs
    assign result = quot;
    assign odd = rem[16];

endmodule