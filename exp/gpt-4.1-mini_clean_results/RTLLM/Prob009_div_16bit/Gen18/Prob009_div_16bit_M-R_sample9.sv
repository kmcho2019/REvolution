module div_16bit (
    input  wire [15:0] A,       // Dividend
    input  wire [7:0]  B,       // Divisor
    output wire [15:0] result,  // Quotient
    output wire [15:0] odd      // Remainder (lower 8 bits valid)
);

    // Intermediate remainder signals: 9 bits wide to hold remainder + carry
    wire [8:0] rem [0:16];

    // Initial remainder is zero
    assign rem[0] = 9'd0;

    genvar i;
    generate
        for (i = 0; i < 16; i = i + 1) begin : division_chain
            // Shift remainder left by 1 and append current dividend bit
            wire [8:0] shifted_rem = {rem[i][7:0], A[15 - i]};

            // Compare shifted remainder with divisor extended to 9 bits
            wire rem_ge_div = (shifted_rem >= {1'b0, B});

            // Subtract divisor if shifted remainder >= divisor
            assign rem[i + 1] = rem_ge_div ? (shifted_rem - {1'b0, B}) : shifted_rem;
        end
    endgenerate

    // Extract quotient bits from comparison results
    // Since quotient bit at iteration i corresponds to whether subtraction occurred
    // We'll reconstruct quotient by re-implementing comparisons here

    wire [15:0] quotient;
    generate
        for (i = 0; i < 16; i = i + 1) begin : quotient_bits_gen
            wire [8:0] current_shifted_rem = {rem[i][7:0], A[15 - i]};
            assign quotient[15 - i] = (current_shifted_rem >= {1'b0, B}) ? 1'b1 : 1'b0;
        end
    endgenerate

    // Assign outputs
    assign result = quotient;
    // Remainder is the final remainder after processing all bits; zero-extend to 16 bits
    assign odd = {8'd0, rem[16][7:0]};

endmodule