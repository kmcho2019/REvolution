module div_16bit(
    input [15:0] A,
    input [7:0] B,
    output [15:0] result,
    output [15:0] odd
);

reg [15:0] a_reg;
reg [7:0] b_reg;
reg [15:0] result_reg;
reg [15:0] odd_reg;

always @(*)
begin
    a_reg = A;
    b_reg = B;
end

always @(*)
begin
    result_reg = 0;
    odd_reg = a_reg;
    for (int i = 15; i >= 8; i--)
    begin
        reg [7:0] temp_high;
        reg [7:0] temp_low;
        reg [7:0] temp_diff;
        temp_high = odd_reg >> (i-7);
        if (temp_high >= b_reg)
        begin
            result_reg = result_reg | (1 << (i-8));
            temp_diff = temp_high - b_reg;
        end
        else
        begin
            temp_diff = temp_high;
        end
        temp_low = odd_reg % (1 << (i-7));
        odd_reg = (temp_diff << (i-7)) | temp_low;
    end
    result = result_reg;
    odd = odd_reg;
end

endmodule