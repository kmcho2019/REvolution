module div_16bit (
    input  wire [15:0] A,       // Dividend
    input  wire [7:0]  B,       // Divisor
    output reg  [15:0] result,  // Quotient
    output reg  [15:0] odd      // Remainder (zero extended lower 8 bits)
);

    localparam DIVIDEND_WIDTH = 16;
    localparam DIVISOR_WIDTH  = 8;
    localparam REM_WIDTH      = DIVISOR_WIDTH + 1; // 9 bits remainder to hold borrow/carry

    integer i;
    reg [REM_WIDTH-1:0] remainder;  // Current remainder during division

    always @(*) begin
        remainder = {REM_WIDTH{1'b0}};
        result    = 0;

        // Iterate over each bit of dividend from MSB to LSB
        for (i = DIVIDEND_WIDTH-1; i >= 0; i = i - 1) begin
            // Shift remainder left by 1 and bring in current dividend bit
            remainder = {remainder[DIVISOR_WIDTH-1:0], A[i]};
            
            // If remainder >= divisor, subtract divisor and set quotient bit
            if (remainder >= {1'b0, B}) begin
                remainder = remainder - {1'b0, B};
                result[i] = 1'b1;
            end else begin
                result[i] = 1'b0;
            end
        end

        // Assign remainder output: zero-extend remainder's lower 8 bits to 16 bits
        odd = { {(DIVIDEND_WIDTH - DIVISOR_WIDTH){1'b0}}, remainder[DIVISOR_WIDTH-1:0] };
    end

endmodule