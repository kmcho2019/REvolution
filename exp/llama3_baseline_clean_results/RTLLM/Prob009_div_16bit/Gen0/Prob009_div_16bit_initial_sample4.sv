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
    reg [15:0] temp_a;
    reg [7:0] temp_b;
    reg [15:0] temp_result;
    reg [15:0] temp_odd;
    temp_a = a_reg;
    temp_b = b_reg;
    temp_result = 16'd0;
    temp_odd = 16'd0;

    for (int i = 15; i >= 8; i--) begin
        if (temp_a[15:8] > temp_b) begin
            temp_result[15 - i] = 1'b1;
            temp_odd[15:8] = temp_a[15:8] - temp_b;
        end else begin
            temp_result[15 - i] = 1'b0;
            temp_odd[15:8] = temp_a[15:8];
        end
        temp_a = {temp_odd[15:8], temp_a[7:0]};
    end

    for (int i = 7; i >= 0; i--) begin
        if (temp_a[7:0] > temp_b) begin
            temp_result[7 - i] = 1'b1;
            temp_odd[7:0] = temp_a[7:0] - temp_b;
        end else begin
            temp_result[7 - i] = 1'b0;
            temp_odd[7:0] = temp_a[7:0];
        end
        temp_a = {temp_odd[7:0], 8'd0};
    end

    result = temp_result;
    odd = temp_odd;
end

endmodule