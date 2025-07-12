module div_16bit (
    input  wire [15:0] A,       // Dividend
    input  wire [7:0]  B,       // Divisor
    output wire [15:0] result,  // Quotient
    output wire [15:0] odd      // Remainder (lower 8 bits valid)
);

    // We'll create 17 remainder signals (from initial 0 remainder up to after 16 bits processed)
    // Each remainder is 9 bits wide: 8 bits plus carry/borrow bit for comparison
    wire [8:0] rem [0:16];
    wire       quotient_bits [15:0];

    // Initial remainder is zero
    assign rem[0] = 9'd0;

    genvar i;
    generate
        for (i = 0; i < 16; i = i + 1) begin : div_loop
            // Shift remainder left by 1 bit and append current dividend bit (MSB first)
            wire [8:0] rem_shifted = {rem[i][7:0], A[15 - i]};
            
            // Compare remainder with divisor (zero-extended to 9 bits)
            wire rem_ge_div = (rem_shifted >= {1'b0, B});
            
            // Subtract divisor if remainder >= divisor
            assign rem[i+1] = rem_ge_div ? (rem_shifted - {1'b0, B}) : rem_shifted;

            // Set quotient bit accordingly (MSB first)
            assign quotient_bits[15 - i] = rem_ge_div ? 1'b1 : 1'b0;
        end
    endgenerate

    // Assemble quotient vector from quotient_bits
    wire [15:0] quotient_vector;
    generate
        for (i = 0; i < 16; i = i + 1) begin : quotient_assemble
            assign quotient_vector[i] = quotient_bits[i];
        end
    endgenerate

    // Output assignments
    assign result = quotient_vector;
    assign odd = {8'd0, rem[16][7:0]};  // zero extend remainder to 16 bits

endmodule