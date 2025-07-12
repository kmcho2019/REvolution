module div_16bit (
    input  wire [15:0] A,      // Dividend
    input  wire [7:0]  B,      // Divisor
    output wire [15:0] result, // Quotient
    output wire [15:0] odd     // Remainder (lower 8 bits valid)
);

    // Input registers as wires (combinational)
    wire [15:0] a_reg = A;
    wire [7:0]  b_reg = B;

    // Remainder stages: 9 bits wide, 17 stages (0 to 16)
    wire [8:0] rem [0:16];
    // Quotient bits vector [15:0]
    wire [15:0] quot_bits;

    // Initial remainder zero
    assign rem[0] = 9'd0;

    genvar i;
    generate
        for (i = 0; i < 16; i = i + 1) begin : div_loop
            // Shift remainder left by 1 and append next dividend bit from MSB to LSB
            wire [8:0] rem_shift = {rem[i][7:0], a_reg[15 - i]};
            wire rem_ge_b = (rem_shift >= {1'b0, b_reg});
            assign rem[i+1] = rem_ge_b ? (rem_shift - {1'b0, b_reg}) : rem_shift;
            assign quot_bits[15 - i] = rem_ge_b ? 1'b1 : 1'b0;
        end
    endgenerate

    // Assign output ports directly from wire values
    assign result = quot_bits;
    assign odd = {8'd0, rem[16][7:0]}; // zero extend remainder to 16 bits

endmodule