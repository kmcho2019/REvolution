module div_16bit (
    input  wire [15:0] A,        // Dividend
    input  wire [7:0]  B,        // Divisor
    output reg  [15:0] result,   // Quotient
    output reg  [15:0] odd       // Remainder (lower 8 bits valid)
);

    reg [15:0] a_reg;
    reg [7:0]  b_reg;

    integer i;
    reg [8:0] rem;  // 9 bits to hold intermediate remainder (0-8 bits + carry)

    // First always block: latch inputs
    always @(*) begin
        a_reg = A;
        b_reg = B;
    end

    // Second always block: combinational division logic
    always @(*) begin
        rem = 9'd0;
        result = 16'd0;

        for (i = 15; i >= 0; i = i - 1) begin
            // Shift remainder left by 1, bring down next dividend bit
            rem = {rem[7:0], a_reg[i]};
            if (rem[8:1] >= b_reg) begin
                rem[8:1] = rem[8:1] - b_reg;
                result[i] = 1'b1;
            end else begin
                result[i] = 1'b0;
            end
        end

        // Store remainder in lower 8 bits of odd, zero-extend upper bits
        odd = {8'b0, rem[8:1]};
    end

endmodule