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

always @(*) begin
    a_reg = A;
    b_reg = B;
end

always @(*) begin
    reg [15:0] temp_result;
    reg [15:0] temp_odd;
    reg [7:0] divisor;
    reg [15:0] dividend;

    temp_result = 0;
    temp_odd = 0;
    divisor = b_reg;
    dividend = a_reg;

    for (int i = 15; i >= 0; i--) begin
        if (i < 8) begin
            if (dividend >= {divisor, 8'd0}) begin
                temp_result[15-i] = 1;
                dividend = dividend - {divisor, 8'd0};
            end
        end else begin
            if ({dividend[15:8], 8'd0} >= divisor) begin
                temp_result[15-i] = 1;
                dividend = {dividend[15:8] - divisor, dividend[7:0]};
            end else begin
                temp_result[15-i] = 0;
                dividend = {dividend[15:8], dividend[7:0]};
            end
        end
    end

    result_reg = temp_result;
    odd_reg = dividend;
end

assign result = result_reg;
assign odd = odd_reg;

endmodule