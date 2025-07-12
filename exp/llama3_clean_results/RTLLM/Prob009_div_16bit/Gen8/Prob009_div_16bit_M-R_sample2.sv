module div_16bit(
    input  [15:0] A,
    input  [7:0]  B,
    output reg [15:0] result,
    output reg [15:0] odd
);

always @(*) begin
    reg [15:0] dividend;
    reg [7:0] divisor;
    reg [15:0] quotient;
    reg [15:0] remainder;
    reg [7:0] temp;

    dividend = A;
    divisor = B;
    quotient = 0;
    remainder = 0;

    for (int i = 15; i >= 0; i--) begin
        temp = remainder[7:0];
        if (i < 8) begin
            temp = {temp, dividend[i]};
        end else begin
            temp = {temp, dividend[i]};
        end

        if (temp >= divisor) begin
            quotient[15 - i] = 1;
            remainder = {temp - divisor, 8'b0};
        end else begin
            quotient[15 - i] = 0;
            remainder = {temp, 1'b0};
        end
    end

    result = quotient;
    odd = remainder;
end

endmodule