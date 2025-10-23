module div_16bit(
    input [15:0] A,
    input [7:0] B,
    output reg [15:0] result,
    output reg [15:0] odd
);

reg [15:0] dividend;
reg [7:0] divisor;
reg [15:0] quotient;
reg [15:0] remainder;
reg [7:0] temp_remainder;

always @(*) begin
    dividend = A;
    divisor = B;
    quotient = 0;
    remainder = 0;
    temp_remainder = 0;

    for (int i = 15; i >= 0; i = i - 1) begin
        temp_remainder = {remainder[7:0], dividend[i]};
        if (temp_remainder >= {8'd0, divisor}) begin
            quotient = quotient | (1 << i);
            temp_remainder = temp_remainder - {8'd0, divisor};
        end
        remainder = temp_remainder;
    end

    result = quotient;
    odd = {8'd0, remainder[7:0]};
end

endmodule