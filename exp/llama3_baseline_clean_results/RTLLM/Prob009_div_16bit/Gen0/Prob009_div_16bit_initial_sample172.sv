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
    reg [7:0] temp_compare;

    temp_a = a_reg;
    temp_b = b_reg;
    temp_result = 0;
    temp_odd = 0;

    for (int i = 15; i >= 0; i--) begin
        if (i >= 8) begin
            temp_compare = temp_a[15:i];
            if (temp_compare >= temp_b) begin
                temp_result[15-i] = 1;
                temp_a[15:i-8] = temp_a[15:i-8] - temp_b;
            end else begin
                temp_result[15-i] = 0;
            end
            if (i > 8) begin
                temp_a[15:i] = {temp_a[15:i-8], temp_a[i-8]};
            end else begin
                temp_a[15:i] = {temp_a[15:i-8], temp_a[7:0]};
            end
        end else begin
            temp_odd = temp_a;
        end
    end
    result_reg = temp_result;
    odd_reg = temp_odd;
end

assign result = result_reg;
assign odd = odd_reg;

endmodule