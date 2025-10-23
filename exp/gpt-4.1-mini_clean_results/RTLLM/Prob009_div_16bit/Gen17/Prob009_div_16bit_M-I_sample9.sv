module div_16bit (
    input  wire [15:0] A,      // Dividend
    input  wire [7:0]  B,      // Divisor
    output reg  [15:0] result, // Quotient
    output reg  [15:0] odd     // Remainder (lower 8 bits valid, zero-extended)
);

    // Internal registers for latched inputs
    reg [15:0] a_reg;
    reg [7:0]  b_reg;

    // Width parameters
    localparam DIVIDEND_WIDTH = 16;
    localparam DIVISOR_WIDTH  = 8;
    localparam REM_WIDTH      = DIVISOR_WIDTH + 1; // 9 bits for remainder to hold carry/borrow

    // Internal remainder register for iterative calculation
    reg [REM_WIDTH-1:0] remainder;

    integer i;

    // First always block: latch inputs into internal registers combinationally
    always @(*) begin
        a_reg = A;
        b_reg = B;
    end

    // Second always block: combinational division algorithm using shift-subtract loop
    always @(*) begin
        remainder = 0;
        result = 0;

        // Perform division bit by bit from MSB to LSB
        for (i = DIVIDEND_WIDTH-1; i >= 0; i = i - 1) begin
            // Shift left remainder by 1 bit and bring next dividend bit in
            remainder = {remainder[DIVISOR_WIDTH-1:0], a_reg[i]};

            // If remainder >= divisor, subtract divisor and set quotient bit
            if (remainder >= {1'b0, b_reg}) begin
                remainder = remainder - {1'b0, b_reg};
                result[i] = 1'b1;
            end else begin
                result[i] = 1'b0;
            end
        end

        // Zero-extend remainder to 16 bits for odd output
        odd = { {(DIVIDEND_WIDTH - DIVISOR_WIDTH){1'b0}}, remainder[DIVISOR_WIDTH-1:0]};
    end

endmodule