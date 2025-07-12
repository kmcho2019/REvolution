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
    temp_result = 0;
    temp_odd = 0;

    for (int i = 15; i >= 0; i--) begin
        if (i < 8) begin
            temp_odd = {temp_odd[14:0], temp_a[i]};
        end
        if (i >= 8) begin
            if ({temp_a[15:8], 8'd0} >= temp_b) begin
                temp_result[15 - i + 7] = 1;
                temp_a = {temp_a[14:0], 1'b0} - {temp_b, 8'd0};
            end else begin
                temp_a = {temp_a[14:0], 1'b0};
            end
        end
    end

    result = temp_result;
    odd = temp_odd;
end

endmodule