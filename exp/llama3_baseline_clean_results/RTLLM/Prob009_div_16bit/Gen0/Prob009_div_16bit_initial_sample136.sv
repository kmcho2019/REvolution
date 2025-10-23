module div_16bit(
    input [15:0] A,  // 16-bit dividend
    input [7:0] B,   // 8-bit divisor
    output [15:0] result,  // 16-bit quotient
    output [15:0] odd  // 16-bit remainder
);

reg [15:0] a_reg;
reg [7:0] b_reg;

// First always block: Register input values
always @(*) begin
    a_reg = A;
    b_reg = B;
end

// Second always block: Perform division logic
always @(*) begin
    reg [15:0] temp_quotient;
    reg [15:0] temp_remainder;
    reg [7:0] divisor;
    reg [15:0] dividend;

    temp_quotient = 0;
    temp_remainder = 0;
    divisor = b_reg;
    dividend = a_reg;

    for (int i = 15; i >= 0; i--) begin
        if (i >= 8) begin
            if ({dividend[15:8], temp_remainder[7:0]} >= {8'd0, divisor}) begin
                temp_quotient[15-i] = 1;
                temp_remainder = {dividend[15:8], temp_remainder[7:0]} - {8'd0, divisor};
            end else begin
                temp_quotient[15-i] = 0;
                temp_remainder = {dividend[15:8], temp_remainder[7:0]};
            end
            dividend = {8'd0, dividend[7:0]};
        end else begin
            if ({8'd0, temp_remainder[7:0]} >= {8'd0, divisor}) begin
                temp_quotient[15-i] = 1;
                temp_remainder = {8'd0, temp_remainder[7:0]} - {8'd0, divisor};
            end else begin
                temp_quotient[15-i] = 0;
                temp_remainder = {8'd0, temp_remainder[7:0]};
            end
        end
    end

    result = temp_quotient;
    odd = temp_remainder;
end

endmodule