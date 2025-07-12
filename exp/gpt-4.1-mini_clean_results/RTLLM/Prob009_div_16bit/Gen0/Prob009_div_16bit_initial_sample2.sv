module div_16bit (
    input  wire [15:0] A,     // 16-bit dividend
    input  wire [7:0]  B,     // 8-bit divisor
    output reg  [15:0] result, // 16-bit quotient
    output reg  [15:0] odd     // 16-bit remainder
);

reg [15:0] a_reg;
reg [7:0]  b_reg;

integer i;

always @(*) begin
    a_reg = A;
    b_reg = B;
end

always @(*) begin
    // Initialize remainder and quotient
    reg [15:0] remainder;
    reg [15:0] quotient;

    remainder = 0;
    quotient = 0;

    for (i = 15; i >= 0; i = i - 1) begin
        // Shift left remainder by 1 and bring down the next bit of dividend
        remainder = {remainder[14:0], a_reg[i]};
        if (remainder[7:0] >= b_reg) begin
            remainder[7:0] = remainder[7:0] - b_reg;
            quotient[i] = 1'b1;
        end else begin
            quotient[i] = 1'b0;
        end
    end

    result = quotient;
    odd = remainder;
end

endmodule