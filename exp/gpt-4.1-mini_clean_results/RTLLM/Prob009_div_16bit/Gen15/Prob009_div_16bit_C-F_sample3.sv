module div_16bit (
    input  wire [15:0] A,       // Dividend
    input  wire [7:0]  B,       // Divisor
    output reg  [15:0] result,  // Quotient
    output reg  [15:0] odd      // Remainder (lower 8 bits valid)
);

    // Input registers assigned combinationally
    reg [15:0] a_reg;
    reg [7:0]  b_reg;

    always @(*) begin
        a_reg = A;
        b_reg = B;
    end

    // Division function:
    // Iteratively shift in dividend bits from MSB to LSB,
    // subtract divisor when remainder >= divisor,
    // set quotient bits accordingly.
    // Returns {quotient[15:0], remainder[8:0]}.
    function [24:0] divide;
        input [15:0] dividend;
        input [7:0]  divisor;
        integer i;
        reg [8:0] remainder;
        reg [15:0] quotient;
    begin
        remainder = 9'd0;
        quotient = 16'd0;

        for (i = 15; i >= 0; i = i - 1) begin
            remainder = {remainder[7:0], dividend[i]};
            if (remainder >= {1'b0, divisor}) begin
                remainder = remainder - {1'b0, divisor};
                quotient[i] = 1'b1;
            end else begin
                quotient[i] = 1'b0;
            end
        end
        divide = {quotient, remainder};
    end
    endfunction

    // Combinational logic block performing division
    always @(*) begin
        reg [24:0] div_res;
        div_res = divide(a_reg, b_reg);
        result = div_res[24:9];
        odd = {8'd0, div_res[8:0]};  // zero-extend remainder to 16 bits
    end

endmodule