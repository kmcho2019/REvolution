module div_16bit (
    input  wire [15:0] A,       // Dividend
    input  wire [7:0]  B,       // Divisor
    output wire [15:0] result,  // Quotient
    output wire [15:0] odd      // Remainder (lower 8 bits valid)
);

    // Internal wires for remainder at each step (0 to 16)
    wire [7:0] rem [0:16];

    // Quotient bits wires
    wire [15:0] quotient_bits;

    assign rem[0] = 8'd0;

    genvar i;
    generate
        for (i = 0; i < 16; i = i + 1) begin : division_steps
            // Concatenate remainder and next dividend bit
            wire [8:0] rem_shifted_ext = {rem[i], A[15 - i]};
            // Compute difference with divisor
            wire [8:0] diff = rem_shifted_ext - {1'b0, B};
            // Quotient bit is 1 if no borrow (MSB of diff is 0)
            wire q_bit = ~diff[8];

            // Assign quotient bit directly indexed MSB to LSB
            assign quotient_bits[15 - i] = q_bit;

            // Next remainder is diff[7:0] if q_bit == 1 else rem_shifted_ext[7:0]
            assign rem[i + 1] = q_bit ? diff[7:0] : rem_shifted_ext[7:0];
        end
    endgenerate

    assign result = quotient_bits;
    // Zero-extend remainder to 16 bits
    assign odd = {8'd0, rem[16]};

endmodule