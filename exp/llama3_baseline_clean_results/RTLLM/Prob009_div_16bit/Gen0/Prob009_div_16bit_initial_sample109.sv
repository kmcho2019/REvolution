module div_16bit(
    input [15:0] A,  // 16-bit dividend
    input [7:0] B,   // 8-bit divisor
    output reg [15:0] result,  // 16-bit quotient
    output reg [15:0] odd     // 16-bit remainder
);

reg [15:0] a_reg;
reg [7:0] b_reg;

always @(A or B) begin
    a_reg = A;
    b_reg = B;
end

always @(A or B) begin
    reg [15:0] temp_a;
    reg [7:0] temp_b;
    reg [15:0] temp_result;
    temp_a = a_reg;
    temp_b = b_reg;
    temp_result = 0;
    
    for (int i = 15; i >= 0; i = i - 1) begin
        if (i >= 8) begin
            if (temp_a[15:i] >= {temp_b, 8'd0}) begin
                temp_result[i] = 1;
                temp_a = (temp_a[15:i] - {temp_b, 8'd0}) << 1 | temp_a[i-1:0];
            end else begin
                temp_result[i] = 0;
                temp_a = temp_a[15:i] << 1 | temp_a[i-1:0];
            end
        end else begin
            if (temp_a[7:0] >= temp_b) begin
                temp_result[i] = 1;
                temp_a[7:0] = temp_a[7:0] - temp_b;
            end else begin
                temp_result[i] = 0;
            end
        end
    end
    result = temp_result;
    odd = temp_a[7:0];
end

endmodule