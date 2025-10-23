module div_16bit(
    input  [15:0] A,
    input  [7:0]  B,
    output reg [15:0] result,
    output reg [15:0] odd
);

reg [15:0] quotient;
reg [15:0] remainder;
reg [7:0] divisor;

always @(*) begin
    if (B == 0) begin
        result = 0;
        odd = 0;
    end else begin
        quotient = 0;
        remainder = A;
        divisor = B;

        for (int i = 15; i >= 0; i--) begin
            if (i >= 8) begin
                if (remainder[15:8] >= divisor) begin
                    quotient[15 - i] = 1;
                    remainder = (remainder[15:8] - divisor) << 8 | remainder[7:0];
                end else begin
                    remainder = remainder[15:8] << 8 | remainder[7:0];
                end
            end else begin
                if (remainder[15:8] >= divisor) begin
                    quotient[15 - i] = 1;
                    remainder = (remainder[15:8] - divisor) << 8 | remainder[7:0];
                end else begin
                    remainder = remainder[15:8] << 8 | remainder[7:0];
                end
            end
        end

        result = quotient;
        odd = remainder;
    end
end

endmodule