module div_16bit (
    input  wire [15:0] A,       // Dividend
    input  wire [7:0]  B,       // Divisor
    output wire [15:0] result,  // Quotient
    output wire [15:0] odd      // Remainder (lower 8 bits valid)
);

    // Intermediate wires for remainder at each stage (9 bits wide)
    wire [8:0] rem_stage [0:16];
    wire [15:0] quotient;

    assign rem_stage[0] = 9'd0;

    genvar i;
    generate
        for (i = 0; i < 16; i = i + 1) begin : div_loop
            wire [8:0] rem_shifted;
            wire [8:0] rem_sub;
            wire       bit_set;

            // Shift previous remainder left by 1, bring in next bit of dividend
            assign rem_shifted = {rem_stage[i][7:0], A[15 - i]};

            // Subtract divisor if possible
            assign rem_sub = rem_shifted - {1'b0, B};

            assign bit_set = (rem_shifted >= {1'b0, B});

            assign rem_stage[i + 1] = bit_set ? rem_sub : rem_shifted;

            assign quotient[15 - i] = bit_set;
        end
    endgenerate

    assign result = quotient;
    assign odd = {8'd0, rem_stage[16][7:0]};

endmodule