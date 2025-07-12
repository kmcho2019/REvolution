module div_16bit (
    input  wire [15:0] A,       // Dividend
    input  wire [7:0]  B,       // Divisor
    output wire [15:0] result,  // Quotient
    output wire [15:0] odd      // Remainder (lower 8 bits valid, zero-extended)
);

    // Parameters for bit widths
    localparam DIVIDEND_WIDTH = 16;
    localparam DIVISOR_WIDTH  = 8;
    localparam REM_WIDTH      = DIVISOR_WIDTH + 1;  // 9 bits remainder to hold possible borrow/carry

    // Remainder array: 17 stages (initial + 16 bits)
    wire [REM_WIDTH-1:0] rem [0:DIVIDEND_WIDTH];

    // Quotient bits wire
    wire [DIVIDEND_WIDTH-1:0] quotient;

    // Initial remainder is zero
    assign rem[0] = {REM_WIDTH{1'b0}};

    genvar i;
    generate
        for (i = 0; i < DIVIDEND_WIDTH; i = i + 1) begin : div_loop
            // Shift left remainder by 1, bring in next dividend bit (from MSB to LSB)
            wire [REM_WIDTH-1:0] rem_shifted = {rem[i][DIVISOR_WIDTH-1:0], A[DIVIDEND_WIDTH-1 - i]};

            // Compare shifted remainder with divisor
            wire rem_ge_div = (rem_shifted >= {1'b0, B});

            // Subtract divisor if remainder >= divisor; else keep remainder
            assign rem[i+1] = rem_ge_div ? (rem_shifted - {1'b0, B}) : rem_shifted;

            // Set quotient bit accordingly (MSB quotient at highest bit)
            assign quotient[DIVIDEND_WIDTH-1 - i] = rem_ge_div ? 1'b1 : 1'b0;
        end
    endgenerate

    // Output assignments
    assign result = quotient;
    assign odd    = { {(DIVIDEND_WIDTH - DIVISOR_WIDTH){1'b0}}, rem[DIVIDEND_WIDTH][DIVISOR_WIDTH-1:0] };
    // odd is zero-extended remainder from lower 8 bits of final remainder stage

endmodule