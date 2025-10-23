module div_16bit (
    input   [15:0] A,  // 16-bit dividend
    input   [7:0]  B,  // 8-bit divisor
    output  [15:0] result,  // 16-bit quotient
    output  [15:0] odd    // 16-bit remainder
);

reg [15:0] a_reg;
reg [7:0]  b_reg;

always @(*) begin
    a_reg = A;
    b_reg = B;
end

always @(*) begin
    reg [15:0] temp_a;
    reg [7:0]  temp_b;
    reg [15:0] quotient;
    reg [15:0] remainder;
    integer i;

    temp_a = a_reg;
    temp_b = b_reg;
    quotient = 0;
    remainder = 0;

    for (i = 15; i >= 0; i = i - 1) begin
        if (temp_a[15:8] >= temp_b) begin
            quotient = quotient << 1;
            quotient = quotient | 1;
            remainder = (temp_a[15:8] - temp_b) << 8;
        end else begin
            quotient = quotient << 1;
            remainder = temp_a[15:8] << 8;
        end

        temp_a = {remainder[7:0], temp_a[7:0]};
    end

    result = quotient;
    odd = remainder;
end

endmodule