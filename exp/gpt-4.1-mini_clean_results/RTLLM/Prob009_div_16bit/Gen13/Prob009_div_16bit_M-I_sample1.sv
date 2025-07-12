module div_16bit (
    input  wire [15:0] A,       // Dividend
    input  wire [7:0]  B,       // Divisor
    output reg  [15:0] result,  // Quotient
    output reg  [15:0] odd      // Remainder (lower 8 bits valid)
);

    // Input registers (combinational)
    reg [15:0] a_reg;
    reg [7:0]  b_reg;

    always @(*) begin
        a_reg = A;
        b_reg = B;
    end

    integer i;
    reg [7:0] remainder;  // 8-bit remainder
    reg [15:0] quotient_temp;

    always @(*) begin
        remainder = 8'd0;
        quotient_temp = 16'd0;

        // Perform division bit by bit from MSB to LSB
        for (i = 15; i >= 0; i = i - 1) begin
            // Shift remainder left by 1 and bring in next dividend bit
            remainder = {remainder[6:0], a_reg[i]};

            // If remainder >= divisor, subtract divisor and set quotient bit
            if (remainder >= b_reg) begin
                remainder = remainder - b_reg;
                quotient_temp[i] = 1'b1;
            end else begin
                quotient_temp[i] = 1'b0;
            end
        end
        result = quotient_temp;
        odd = {8'd0, remainder};  // zero-extend remainder
    end

endmodule