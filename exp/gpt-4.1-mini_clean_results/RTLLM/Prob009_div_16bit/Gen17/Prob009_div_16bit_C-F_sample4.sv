module div_16bit (
    input  wire [15:0] A,       // Dividend
    input  wire [7:0]  B,       // Divisor
    output wire [15:0] result,  // Quotient
    output wire [15:0] odd      // Remainder (lower 8 bits valid)
);

    // Stage 1: Combinational "registers" for inputs as wires (aliasing inputs)
    wire [15:0] a_reg = A;
    wire [7:0]  b_reg = B;

    // Stage 2: Division pipeline signals
    // 17 remainder stages (0 to 16), each 9 bits wide (1 extra bit for subtraction borrow)
    wire [8:0] rem [0:16];
    wire [15:0] quotient_bits;

    // Initial remainder is zero
    assign rem[0] = 9'd0;

    genvar i;
    generate
        for (i = 0; i < 16; i = i + 1) begin : div_step
            // Shift remainder left by 1 bit and bring down next dividend bit (MSB to LSB)
            wire [8:0] rem_shift = {rem[i][7:0], a_reg[15 - i]};
            // Compare remainder with divisor zero-extended
            wire rem_ge_b = (rem_shift >= {1'b0, b_reg});
            // Conditionally subtract divisor if remainder >= divisor
            assign rem[i+1] = rem_ge_b ? (rem_shift - {1'b0, b_reg}) : rem_shift;
            // Set quotient bit according to comparison
            assign quotient_bits[15 - i] = rem_ge_b ? 1'b1 : 1'b0;
        end
    endgenerate

    // Output assignments
    assign result = quotient_bits;
    assign odd = {8'd0, rem[16][7:0]}; // zero-extend remainder to 16 bits

endmodule