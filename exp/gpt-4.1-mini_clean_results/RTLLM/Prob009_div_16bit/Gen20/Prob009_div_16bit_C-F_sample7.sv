module div_16bit (
    input  wire [15:0] A,       // Dividend
    input  wire [7:0]  B,       // Divisor
    output reg  [15:0] result,  // Quotient
    output reg  [15:0] odd      // Remainder (lower 8 bits valid)
);

    // Internal registers to hold inputs combinationally
    reg [15:0] a_reg;
    reg [7:0]  b_reg;

    // First always block: latch inputs on any change (combinational)
    always @(*) begin
        a_reg = A;
        b_reg = B;
    end

    // Intermediate remainder array: 9 bits wide to hold remainder shifted + incoming bit
    reg [8:0] rem [0:16];
    reg [15:0] quot_bits;

    integer i;

    // Second always block: combinational division logic
    always @(*) begin
        rem[0] = 9'd0;  // Initial remainder is zero

        // Iterate over each bit of dividend, MSB first
        for (i = 0; i < 16; i = i + 1) begin
            // Shift previous remainder left by 1 and bring down next dividend bit
            rem[i+1] = {rem[i][7:0], a_reg[15 - i]};
            // Compare and subtract divisor if possible
            if (rem[i+1] >= {1'b0, b_reg}) begin
                rem[i+1] = rem[i+1] - {1'b0, b_reg};
                quot_bits[15 - i] = 1'b1;
            end else begin
                quot_bits[15 - i] = 1'b0;
            end
        end

        // Assign outputs: quotient and zero-extended remainder (lower 8 bits valid)
        result = quot_bits;
        odd = {8'd0, rem[16][7:0]};
    end

endmodule