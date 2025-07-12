module div_16bit(
    input [15:0] A,
    input [7:0] B,
    output reg [15:0] result,
    output reg [15:0] odd
);

reg [15:0] quotient;
reg [15:0] remainder;
reg [7:0] temp;

always @(*) begin
    quotient = 0;
    remainder = 0;

    for (int i = 15; i >= 8; i--) begin
        remainder = {remainder[7:0], A[i]};
        if (remainder >= {8'd0, B}) begin
            quotient = quotient | (1 << (i - 8));
            remainder = remainder - {8'd0, B};
        end
    end

    temp = remainder[7:0];

    for (int i = 7; i >= 0; i--) begin
        temp = {temp[6:0], A[i]};
        if (temp >= B) begin
            quotient = quotient | (1 << i);
            temp = temp - B;
        end
    end

    result = quotient;
    odd = {8'd0, temp};
end

endmodule