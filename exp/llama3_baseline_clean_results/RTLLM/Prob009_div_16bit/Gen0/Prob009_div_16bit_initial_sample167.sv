module div_16bit(
    input [15:0] A,
    input [7:0] B,
    output reg [15:0] result,
    output reg [15:0] odd
);

reg [15:0] a_reg;
reg [7:0] b_reg;

always @(*) begin
    a_reg = A;
    b_reg = B;
end

always @(*) begin
    reg [15:0] temp_result;
    reg [15:0] temp_odd;
    temp_result = 0;
    temp_odd = a_reg;

    for (int i = 15; i >= 0; i = i - 1) begin
        reg [7:0] temp_dividend;
        if (i < 8) begin
            temp_dividend = temp_odd[7:0];
        end else begin
            temp_dividend = {temp_odd[15], temp_odd[14], temp_odd[13], temp_odd[12], temp_odd[11], temp_odd[10], temp_odd[9], temp_odd[8]};
        end

        if (temp_dividend >= b_reg) begin
            temp_result = {1'b1, temp_result[14:0]};
            temp_odd = (temp_dividend - b_reg) << (i - 7);
        end else begin
            temp_result = {1'b0, temp_result[14:0]};
            if (i > 7) begin
                temp_odd = {temp_odd[14:0], temp_odd[15]};
            end else begin
                temp_odd = temp_odd;
            end
        end
    end

    result = temp_result;
    odd = temp_odd;
end

endmodule