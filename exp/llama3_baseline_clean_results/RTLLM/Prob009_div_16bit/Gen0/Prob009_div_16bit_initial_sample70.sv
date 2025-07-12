module div_16bit(
    input [15:0] A, // 16-bit dividend
    input [7:0] B,  // 8-bit divisor
    output [15:0] result, // 16-bit quotient
    output [15:0] odd    // 16-bit remainder
);

reg [15:0] a_reg; // register to hold the dividend
reg [7:0] b_reg;  // register to hold the divisor

// First always block: update the values of a_reg and b_reg
always @(*) begin
    a_reg = A;
    b_reg = B;
end

// Second always block: perform the division operation
always @(*) begin
    reg [15:0] temp_quotient;
    reg [15:0] temp_remainder;
    reg [7:0] temp_b;
    reg [7:0] temp_a;

    temp_quotient = 0;
    temp_remainder = a_reg;

    for (int i = 15; i >= 7; i = i - 1) begin
        temp_a = temp_remainder[15:8];
        if (temp_a >= b_reg) begin
            temp_quotient = temp_quotient << 1;
            temp_quotient = temp_quotient | 1;
            temp_remainder = (temp_a - b_reg) << 8;
            temp_remainder = temp_remainder | (temp_remainder[7:0] >> 8);
        end
        else begin
            temp_quotient = temp_quotient << 1;
            temp_remainder = temp_remainder << 1;
        end
    end

    // calculate the remainder
    temp_b = temp_remainder[15:8];
    if (temp_b >= b_reg) begin
        odd = temp_b - b_reg;
    end
    else begin
        odd = temp_b;
    end

    result = temp_quotient;
end

endmodule