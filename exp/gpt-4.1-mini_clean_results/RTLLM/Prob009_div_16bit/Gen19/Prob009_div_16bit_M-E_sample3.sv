module div_16bit (
    input  wire [15:0] A,      // Dividend
    input  wire [7:0]  B,      // Divisor
    output reg  [15:0] result, // Quotient
    output reg  [15:0] odd     // Remainder (lower 8 bits valid)
);

    reg [15:0] a_reg;
    reg [7:0]  b_reg;

    always @(*) begin
        a_reg = A;
        b_reg = B;
    end

    integer i;
    reg [8:0] remainder;  // 9 bits to hold possible borrow during subtraction
    reg [15:0] quotient;

    always @(*) begin
        remainder = 9'd0;
        quotient = 16'd0;

        // Long division starting from highest bits
        // Initially, take top 8 bits of a_reg as remainder candidate
        // Then for each bit from MSB to LSB:
        // Shift remainder left by 1, bring down next bit from dividend
        // Compare remainder and divisor, set quotient bit and update remainder accordingly

        for (i = 15; i >= 0; i = i -1) begin
            remainder = {remainder[7:0], a_reg[i]};  // shift left 1 bit, add dividend bit

            if (remainder[8:1] >= b_reg) begin
                remainder[8:1] = remainder[8:1] - b_reg;
                quotient[i] = 1'b1;
            end else begin
                quotient[i] = 1'b0;
            end
        end

        result = quotient;
        odd = {8'd0, remainder[7:0]};  // Remainder zero-extended to 16 bits
    end

endmodule