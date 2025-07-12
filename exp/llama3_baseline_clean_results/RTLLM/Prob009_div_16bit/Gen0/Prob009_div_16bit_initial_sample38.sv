module div_16bit(
    input wire [15:0] A,
    input wire [7:0] B,
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
        reg [15:0] temp_temp_odd;
        reg [7:0] temp_quotient;

        temp_quotient = temp_b;

        if (temp_a[15] == 1) begin
            temp_quotient = temp_quotient - 1;
        end

        if ((temp_a[15:8] > temp_b) || ((temp_a[15:8] == temp_b) && (temp_a[7] == 1))) begin
            temp_result = temp_result | (1 << i);
            temp_temp_odd = temp_a[15:8] - temp_b;
        end else begin
            temp_temp_odd = temp_a[15:8];
        end

        temp_odd[15:1] = temp_temp_odd;
        temp_odd[0] = temp_a[7];

        temp_a = {temp_odd, temp_a[6:0]};
    end

    result = temp_result;
    odd = temp_odd;
end

endmodule