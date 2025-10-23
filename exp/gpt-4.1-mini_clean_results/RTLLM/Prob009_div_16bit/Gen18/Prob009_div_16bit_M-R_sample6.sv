module div_16bit (
    input  wire [15:0] A,       // Dividend
    input  wire [7:0]  B,       // Divisor
    output reg  [15:0] result,  // Quotient
    output reg  [15:0] odd      // Remainder (lower 8 bits valid)
);

    // Internal registers for input values
    reg [15:0] a_reg;
    reg [7:0]  b_reg;

    // Partial remainder is 9 bits wide to hold possible subtraction result
    reg [8:0] remainder;

    integer i;

    // First always block: capture inputs into registers (combinational)
    always @(*) begin
        a_reg = A;
        b_reg = B;
    end

    // Second always block: perform combinational division
    always @(*) begin
        remainder = 9'd0;
        result = 16'd0;
        // Iterate over dividend bits from MSB to LSB
        for (i = 15; i >= 0; i = i - 1) begin
            // Shift remainder left by 1 and bring down next dividend bit
            remainder = {remainder[7:0], a_reg[i]};
            // Compare remainder with divisor
            if (remainder >= {1'b0, b_reg}) begin
                remainder = remainder - {1'b0, b_reg};
                result[i] = 1'b1;
            end else begin
                result[i] = 1'b0;
            end
        end
        // Output remainder zero-extended to 16 bits
        odd = {8'd0, remainder[7:0]};
    end

endmodule