module div_16bit (
    input  wire [15:0] A,       // Dividend
    input  wire [7:0]  B,       // Divisor
    output reg  [15:0] result,  // Quotient
    output reg  [15:0] odd      // Remainder (lower 8 bits valid)
);

    // First stage: combinational 'registers' via wires
    wire [15:0] a_reg = A;
    wire [7:0]  b_reg = B;

    // Internal signals for division pipeline
    wire [8:0] rem [0:16];       // Remainder stages: 9 bits wide, 17 stages (0 to 16)
    wire       quot_bits [15:0]; // Quotient bits

    // Initial remainder is zero
    assign rem[0] = 9'd0;

    genvar i;
    generate
        for (i = 0; i < 16; i = i + 1) begin : division_loop
            // Shift remainder left 1, bring in next dividend bit from MSB to LSB
            wire [8:0] rem_shift = {rem[i][7:0], a_reg[15 - i]};
            // Compare and subtract
            wire rem_ge_b = (rem_shift >= {1'b0, b_reg});
            assign rem[i+1] = rem_ge_b ? (rem_shift - {1'b0, b_reg}) : rem_shift;
            assign quot_bits[15 - i] = rem_ge_b ? 1'b1 : 1'b0;
        end
    endgenerate

    // Assign outputs on any input change (combinational)
    always @(*) begin
        // Concatenate quotient bits into a 16-bit vector
        result = { quot_bits[15], quot_bits[14], quot_bits[13], quot_bits[12],
                   quot_bits[11], quot_bits[10], quot_bits[9], quot_bits[8],
                   quot_bits[7], quot_bits[6], quot_bits[5], quot_bits[4],
                   quot_bits[3], quot_bits[2], quot_bits[1], quot_bits[0] };
        odd = {8'd0, rem[16][7:0]}; // zero-extend remainder to 16 bits
    end

endmodule