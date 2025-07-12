module div_16bit (
    input [15:0] A,
    input [7:0] B,
    output reg [15:0] result,
    output reg [15:0] odd
);

always @(*) begin
    reg [15:0] temp_quotient;
    reg [15:0] temp_remainder;
    reg [15:0] dividend;

    temp_quotient = 0;
    dividend = A;
    temp_remainder = 0;

    for (int i = 15; i >= 0; i--) begin
        temp_remainder = {temp_remainder[14:0], dividend[15]};
        if (temp_remainder >= {B, 8'd0}) begin
            temp_quotient[15 - i] = 1;
            temp_remainder = temp_remainder - {B, 8'd0};
        end else begin
            temp_quotient[15 - i] = 0;
        end
        dividend = dividend << 1;
    end

    result = temp_quotient;
    odd = temp_remainder;
end

endmodule