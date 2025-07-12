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
reg [3:0] counter;

always @(*) begin
    if (B == 8'd0) begin
        result = 16'd0;
        odd = A;
    end else begin
        quotient = 0;
        remainder = A;
        divisor = B;
        counter = 4'd0;

        for (int i = 0; i < 16; i++) begin
            if (remainder[15:8] >= divisor) begin
                quotient[counter] = 1'b1;
                remainder[7:0] = remainder[7:0] - divisor;
            end else begin
                quotient[counter] = 1'b0;
            end

            if (counter < 4'd15) begin
                remainder[15:8] = remainder[7:0];
                remainder[7] = (i < 15) ? A[15 - i - 1] : 1'b0;
                counter = counter + 1;
            end
        end

        result = quotient;
        odd = {8'd0, remainder[7:0]};
    end
end

endmodule