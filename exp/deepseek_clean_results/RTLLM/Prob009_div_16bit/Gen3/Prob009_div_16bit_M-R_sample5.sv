module div_16bit (
    input [15:0] A,
    input [7:0] B,
    output [15:0] result,
    output [15:0] odd
);

    wire [15:0] divisor = {8'b0, B};  // Zero-extend divisor once
    wire [15:0] remainder [0:16];     // Remainder at each step
    wire [15:0] partial [0:15];       // Partial dividend at each step
    wire [15:0] quotient_bits [0:15]; // Quotient bits

    // Initialize first remainder with upper 8 bits of dividend
    assign remainder[0] = {8'b0, A[15:8]};
    assign partial[0] = {remainder[0][14:0], A[7]};  // First partial dividend

    genvar i;
    generate
        for (i = 0; i < 15; i = i + 1) begin : div_steps
            // Comparison and subtraction
            wire cmp = (remainder[i] >= divisor);
            assign remainder[i+1] = cmp ? (remainder[i] - divisor) : remainder[i];
            
            // Quotient bit assignment
            assign quotient_bits[i] = {15'b0, cmp};
            
            // Next partial dividend (shift left and bring in next bit)
            assign partial[i+1] = {remainder[i+1][14:0], A[6-i]};
        end
    endgenerate

    // Final remainder calculation
    wire cmp_final = (remainder[15] >= divisor);
    assign remainder[16] = cmp_final ? (remainder[15] - divisor) : remainder[15];
    assign quotient_bits[15] = {15'b0, cmp_final};

    // Combine all quotient bits
    assign result = {quotient_bits[0][0], quotient_bits[1][0], quotient_bits[2][0], 
                    quotient_bits[3][0], quotient_bits[4][0], quotient_bits[5][0],
                    quotient_bits[6][0], quotient_bits[7][0], quotient_bits[8][0],
                    quotient_bits[9][0], quotient_bits[10][0], quotient_bits[11][0],
                    quotient_bits[12][0], quotient_bits[13][0], quotient_bits[14][0],
                    quotient_bits[15][0]};

    assign odd = remainder[16];

endmodule