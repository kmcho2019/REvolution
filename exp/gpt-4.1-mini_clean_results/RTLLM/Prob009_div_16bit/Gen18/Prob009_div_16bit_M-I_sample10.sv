module div_16bit (
    input  wire [15:0] A,       // Dividend
    input  wire [7:0]  B,       // Divisor
    output reg  [15:0] result,  // Quotient
    output reg  [15:0] odd      // Remainder (lower 8 bits valid, zero-extended)
);

    // Parameters for bit widths
    localparam DIVIDEND_WIDTH = 16;
    localparam DIVISOR_WIDTH  = 8;
    localparam REM_WIDTH      = DIVISOR_WIDTH + 1;  // 9 bits remainder to hold possible borrow/carry

    // Internal variables for division
    integer i;
    reg [REM_WIDTH-1:0] remainder;
    reg [DIVIDEND_WIDTH-1:0] quotient;

    always @(*) begin
        remainder = {REM_WIDTH{1'b0}};
        quotient = {DIVIDEND_WIDTH{1'b0}};
        // Iterate over each bit from MSB to LSB
        for (i = DIVIDEND_WIDTH-1; i >= 0; i = i - 1) begin
            // Shift remainder left by 1 and bring down next dividend bit
            remainder = {remainder[REM_WIDTH-2:0], A[i]};
            // Perform subtraction: if remainder >= divisor, set quotient bit and update remainder
            if (remainder >= {1'b0, B}) begin
                remainder = remainder - {1'b0, B};
                quotient[i] = 1'b1;
            end else begin
                quotient[i] = 1'b0;
            end
        end
        result = quotient;
        odd = {{(DIVIDEND_WIDTH - DIVISOR_WIDTH){1'b0}}, remainder[DIVISOR_WIDTH-1:0]}; // zero-extend remainder to 16 bits
    end

endmodule