module div_16bit(
    input [15:0] A,
    input [7:0] B,
    output reg [15:0] result,
    output reg [15:0] odd
    );

reg [15:0] a_reg;
reg [7:0] b_reg;

always @(*)
begin
    a_reg <= A;
    b_reg <= B;
end

always @(*)
begin
    result = 0;
    odd = a_reg;
    for (int i = 15; i >= 8; i = i - 1)
    begin
        if (odd[15:8] >= b_reg)
        begin
            result = result << 1;
            result[0] = 1;
            odd = {odd[14:0], 1'b0} - {b_reg, 8'b0};
        end
        else
        begin
            result = result << 1;
            odd = {odd[14:0], 1'b0};
        end
    end
    if (odd[7:0] >= b_reg)
    begin
        result = result << 1;
        result[0] = 1;
        odd = odd - {b_reg, 8'b0};
    end
    else
    begin
        result = result << 1;
    end
end
endmodule