module div_16bit(
    input [15:0] A, // 16-bit dividend
    input [7:0] B,  // 8-bit divisor
    output [15:0] result, // 16-bit quotient
    output [15:0] odd // 16-bit remainder
);

reg [15:0] a_reg;
reg [7:0] b_reg;

// First always block: update registers with input values
always @(*) begin
    a_reg = A;
    b_reg = B;
end

// Second always block: perform division operation
always @(*) begin
    reg [15:0] temp_quotient;
    reg [15:0] temp_remainder;
    reg [7:0] divisor;

    temp_quotient = 0;
    temp_remainder = a_reg;
    divisor = b_reg;

    for (int i = 15; i >= 0; i = i - 1) begin
        if (temp_remainder[15:8] >= divisor) begin
            temp_quotient = (temp_quotient << 1) | 1;
            temp_remainder = (temp_remainder << 1) - (divisor << (i - 7));
        end else begin
            temp_quotient = temp_quotient << 1;
            temp_remainder = (temp_remainder << 1);
        end
    end

    result = temp_quotient;
    odd = temp_remainder;
end

endmodule