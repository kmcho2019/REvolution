module div_16bit (
    input  wire [15:0] A,       // Dividend
    input  wire [7:0]  B,       // Divisor
    output wire [15:0] result,  // Quotient
    output wire [15:0] odd      // Remainder (lower 8 bits valid)
);

    // Directly use input signals without combinational registers
    wire [15:0] a = A;
    wire [7:0]  b = B;

    // Array of remainder signals: 9 bits each (8 bits + carry)
    // rem[0] initialized to 0
    wire [8:0] rem [0:16];
    wire quotient_bits [15:0];

    // Initial remainder zero
    assign rem[0] = 9'd0;

    genvar i;
    generate
        for (i = 0; i < 16; i = i + 1) begin : div_loop
            // Shift previous remainder left by 1, append current dividend bit
            wire [8:0] rem_shifted = {rem[i][7:0], a[15 - i]};

            // Compare shifted remainder with divisor (zero-extended to 9 bits)
            wire rem_ge_b = (rem_shifted >= {1'b0, b});

            // Subtract divisor if possible, else keep remainder
            assign rem[i+1] = rem_ge_b ? (rem_shifted - {1'b0, b}) : rem_shifted;

            // Set quotient bit accordingly (bit at position from MSB to LSB)
            assign quotient_bits[15 - i] = rem_ge_b ? 1'b1 : 1'b0;
        end
    endgenerate

    // Assemble quotient bits vector
    wire [15:0] quotient_vector;
    generate
        for (i = 0; i < 16; i = i + 1) begin : quotient_assemble
            assign quotient_vector[i] = quotient_bits[i];
        end
    endgenerate

    // Outputs
    assign result = quotient_vector;
    assign odd = {8'd0, rem[16][7:0]};  // zero-extend remainder to 16 bits

endmodule