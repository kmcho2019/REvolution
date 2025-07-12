module div_16bit(
    input [15:0] A,
    input [7:0] B,
    output reg [15:0] result,
    output reg [15:0] odd
);

reg [15:0] a_reg;
reg [7:0] b_reg;

always @(*) begin
    a_reg = A;
    b_reg = B;
end

always @(*) begin
    reg [15:0] dividend;
    reg [15:0] quotient;
    reg [3:0] i;

    result = 0; // Initialize result
    odd = 0; // Initialize odd

    if (b_reg == 0) begin
        result = 0;
        odd = a_reg;
    end else begin
        dividend = a_reg;
        quotient = 0;

        i = 8; // Initialize loop counter
        for (i = 8; i >= 0; i = i - 1) begin
            if (dividend[15-i+:8] >= b_reg) begin
                quotient = quotient + (1 << i);
                dividend = (dividend >> 8) + ((dividend[7:0] - b_reg) << 8);
            end else begin
                dividend = dividend >> 8;
            end
        end

        result = quotient;
        odd = dividend & 16'b1; // Assign remainder to odd
    end
end

endmodule