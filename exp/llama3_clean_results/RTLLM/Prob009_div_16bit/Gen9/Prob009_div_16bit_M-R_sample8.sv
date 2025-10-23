module div_16bit(
    input [15:0] A,
    input [7:0] B,
    output reg [15:0] result,
    output reg [15:0] odd
);

reg [15:0] quotient;
reg [15:0] remainder;
reg [7:0] divisor;
reg [7:0] temp;

always @(*) begin
    quotient = 0;
    remainder = A;
    divisor = B;
end

always @(*) begin
    if (B == 0) begin
        result = 16'd0;
        odd = A;
    end else begin
        for (int i = 15; i >= 8; i--) begin
            if (remainder >= {divisor, 8'd0}) begin
                quotient = quotient | (1 << (i - 8));
                remainder = remainder - {divisor, 8'd0};
            end
            remainder = remainder >> 1;
        end
        for (int i = 7; i >= 0; i--) begin
            if (remainder >= {divisor, {8{i}}} && remainder < {divisor, {8{i + 1}}}) begin
                quotient = quotient | (1 << i);
                remainder = remainder - {divisor, {8{i}}};
            end
        end
        result = quotient;
        odd = {8'd0, remainder};
    end
end

endmodule