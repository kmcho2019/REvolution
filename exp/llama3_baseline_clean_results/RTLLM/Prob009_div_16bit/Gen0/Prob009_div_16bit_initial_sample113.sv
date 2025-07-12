module div_16bit(
    input [15:0] A,  // 16-bit dividend
    input [7:0] B,   // 8-bit divisor
    output [15:0] result,  // 16-bit quotient
    output [15:0] odd  // 16-bit remainder
);

reg [15:0] a_reg;
reg [7:0] b_reg;

always @(A or B) begin
    a_reg = A;
    b_reg = B;
end

always @(A or B) begin
    reg [15:0] temp_a;
    reg [15:0] temp_result;
    reg [15:0] temp_odd;
    reg [7:0] temp_b;
    reg [15:0] temp_quotient;
    integer i;

    temp_a = a_reg;
    temp_b = b_reg;
    temp_result = 16'd0;
    temp_odd = 16'd0;

    for (i = 15; i >= 8; i = i - 1) begin
        if (temp_a[15:8] >= temp_b) begin
            temp_result[15-i+8] = 1;
            temp_odd = temp_a[15:8] - temp_b;
        end else begin
            temp_odd = temp_a[15:8];
        end
        temp_a = {temp_odd, temp_a[7:0]};
    end

    if (temp_a[7:0] >= temp_b) begin
        temp_result[7:0] = temp_a[7:0] / temp_b;
        temp_odd = temp_a[7:0] % temp_b;
    end else begin
        temp_result[7:0] = 8'd0;
        temp_odd = temp_a[7:0];
    end

    result = temp_result;
    odd = temp_odd;
end

endmodule