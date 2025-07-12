module div_16bit (
    input  wire [15:0] A,      // Dividend
    input  wire [7:0]  B,      // Divisor
    output wire [15:0] result, // Quotient
    output wire [15:0] odd     // Remainder (lower 8 bits valid)
);

    // Intermediate remainder wires: rem_wire[i] is remainder after i-th step
    wire [7:0] rem_wire [0:16];
    // Quotient bits wires
    wire [15:0] quotient_bits;

    // Initial remainder is zero
    assign rem_wire[0] = 8'd0;

    genvar i;
    generate
        for (i = 0; i < 16; i = i + 1) begin : div_steps
            wire [8:0] rem_shifted;
            wire [8:0] rem_sub;
            wire step_q;

            // Shift remainder left by 1, append next dividend bit
            assign rem_shifted = {rem_wire[i], A[15 - i]};
            assign rem_sub = rem_shifted - {1'b0, B};

            // Compare and decide quotient bit and next remainder
            assign step_q = (rem_shifted >= {1'b0, B}) ? 1'b1 : 1'b0;

            assign rem_wire[i + 1] = step_q ? rem_sub[7:0] : rem_shifted[7:0];
            assign quotient_bits[15 - i] = step_q;
        end
    endgenerate

    assign result = quotient_bits;
    assign odd = {8'd0, rem_wire[16]};

endmodule