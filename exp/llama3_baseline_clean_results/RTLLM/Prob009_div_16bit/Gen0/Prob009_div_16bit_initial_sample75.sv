module div_16bit(
    input [15:0] A,
    input [7:0] B,
    output [15:0] result,
    output [15:0] odd
);

reg [15:0] a_reg;
reg [7:0] b_reg;

always @(*) begin
    a_reg = A;
    b_reg = B;
end

always @(*) begin
    reg [15:0] temp_a;
    reg [7:0] temp_b;
    reg [15:0] temp_result;
    reg [15:0] temp_odd;

    temp_a = a_reg;
    temp_b = b_reg;
    temp_result = 0;
    temp_odd = 0;

    for (int i = 15; i >= 8; i--) begin
        reg [7:0] higher_bits;
        higher_bits = temp_a >> (i - 7);

        if (higher_bits > temp_b) begin
            temp_result = temp_result << 1;
            temp_result = temp_result | 1;
            temp_odd = (higher_bits - temp_b) << (i - 8);
        end else begin
            temp_result = temp_result << 1;
            temp_odd = higher_bits << (i - 8);
        end

        temp_a = (temp_a << 1) | ((temp_odd >> (i - 8)) & 1);
    end

    result = temp_result;
    odd = temp_odd;
end

endmodule