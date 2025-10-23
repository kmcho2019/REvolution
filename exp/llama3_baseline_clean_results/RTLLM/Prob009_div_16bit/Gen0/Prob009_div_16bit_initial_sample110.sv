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
    reg [15:0] temp_a;
    reg [7:0] temp_b;
    reg [15:0] temp_result;
    reg [15:0] temp_odd;
    integer i;

    temp_a = a_reg;
    temp_b = b_reg;
    temp_result = 0;
    temp_odd = 0;

    for (i = 15; i >= 8; i--) begin
        if (temp_a[15:8] >= temp_b) begin
            temp_result[15-i+7] = 1;
            temp_odd = (temp_a[15:8] - temp_b) << (i-8);
        end else begin
            temp_odd = temp_a[15:8] << (i-8);
        end
        temp_a = (temp_a << 1) | (i > 8 ? temp_a[7] : 0);
    end

    temp_odd = temp_a;

    result_reg = temp_result;
    odd_reg = temp_odd;
end

assign result = result_reg;
assign odd = odd_reg;

endmodule