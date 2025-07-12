module div_16bit(
    input [15:0] A,
    input [7:0] B,
    output [15:0] result,
    output [15:0] odd
);

reg [15:0] a_reg;
reg [7:0] b_reg;

always @(*)
begin
    a_reg = A;
    b_reg = B;
end

always @(*)
begin
    reg [15:0] temp_result;
    reg [15:0] temp_odd;
    reg [7:0] divisor;
    reg [15:0] dividend;

    temp_result = 0;
    temp_odd = a_reg;
    divisor = b_reg;

    for (int i = 15; i >= 0; i = i - 1)
    begin
        if (temp_odd[15:8] >= divisor)
        begin
            temp_result = temp_result << 1;
            temp_result[0] = 1;
            temp_odd = (temp_odd - (divisor << 8)) >> 1;
            temp_odd[0] = temp_odd[15];
        end
        else
        begin
            temp_result = temp_result << 1;
            temp_odd = temp_odd >> 1;
            temp_odd[0] = temp_odd[15];
        end
    end

    result = temp_result;
    odd = temp_odd;
end

endmodule