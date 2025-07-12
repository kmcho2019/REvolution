module div_16bit(
    input [15:0] A,
    input [7:0] B,
    output reg [15:0] result,
    output reg [15:0] odd
);

reg [7:0] lut_quotient [256];
reg [7:0] lut_remainder [256];

always @(*) begin
    for (int i = 0; i < 256; i++) begin
        lut_quotient[i] = i / B;
        lut_remainder[i] = i % B;
    end
end

reg [15:0] temp_quotient;
reg [15:0] temp_remainder;

always @(*) begin
    temp_quotient = 0;
    temp_remainder = 0;

    // Stage 1: Divide the most significant 8 bits of the dividend
    temp_quotient = lut_quotient[A[15:8]];
    temp_remainder = lut_remainder[A[15:8]];

    // Stage 2: Divide the remaining 8 bits of the dividend
    temp_quotient = {temp_quotient, lut_quotient[(temp_remainder * 256 + A[7:0]) / B]};
    temp_remainder = (temp_remainder * 256 + A[7:0]) % B;

    result = temp_quotient;
    odd = {8'd0, temp_remainder};
end

endmodule