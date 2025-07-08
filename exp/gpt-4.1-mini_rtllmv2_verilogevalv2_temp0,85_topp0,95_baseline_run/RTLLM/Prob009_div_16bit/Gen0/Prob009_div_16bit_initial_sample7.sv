module div_16bit(
    input  wire [15:0] A,
    input  wire [7:0]  B,
    output reg  [15:0] result,
    output reg  [15:0] odd
);

reg [15:0] a_reg;
reg [7:0]  b_reg;

always @(*) begin
    a_reg = A;
    b_reg = B;
end

integer i;
reg [15:0] remainder_temp;
reg [15:0] quotient_temp;
reg [7:0]  divisor;

always @(*) begin
    divisor = b_reg;
    remainder_temp = 0;
    quotient_temp = 0;

    // Loop over all bits of dividend from MSB to LSB
    for (i = 15; i >= 0; i = i - 1) begin
        // Shift remainder left by 1 and concatenate next dividend bit
        remainder_temp = {remainder_temp[14:0], a_reg[i]};

        // Extract upper 8 bits of remainder for comparison
        if (remainder_temp[15:8] >= divisor) begin
            // Set quotient bit
            quotient_temp[i] = 1'b1;

            // Subtract divisor from upper bits of remainder
            remainder_temp[15:8] = remainder_temp[15:8] - divisor;
        end else begin
            quotient_temp[i] = 1'b0;
        end
    end

    result = quotient_temp;
    odd = remainder_temp;
end

endmodule