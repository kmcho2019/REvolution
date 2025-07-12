module div_16bit(
    input [15:0] A,
    input [7:0] B,
    output reg [15:0] result,
    output reg [15:0] odd
);

reg [15:0] a_reg;
reg [7:0] b_reg;

// Always block to update input values to internal registers
always @(*) begin
    a_reg = A;
    b_reg = B;
end

// Always block to perform the division operation
always @(*) begin
    reg [15:0] temp_a;
    reg [7:0] temp_b;
    reg [15:0] temp_result;
    reg [15:0] temp_odd;

    temp_a = a_reg;
    temp_b = b_reg;
    temp_result = 0;
    temp_odd = 0;

    for (int i = 15; i >= 8; i--) begin
        if (temp_a[15:i] >= {8'b0, temp_b}) begin
            temp_result[15-i+7] = 1;
            temp_odd = temp_a[15:i] - {8'b0, temp_b};
        end else begin
            temp_odd = temp_a[15:i];
        end
        temp_a = {temp_odd, temp_a[7:0]};
    end

    for (int i = 7; i >= 0; i--) begin
        if (temp_a[15:i] >= {8'b0, temp_b}) begin
            temp_result[15-i] = 1;
            temp_odd = temp_a[15:i] - {8'b0, temp_b};
        end else begin
            temp_odd = temp_a[15:i];
        end
        temp_a = {temp_odd, temp_a[7:0]};
    end

    result = temp_result;
    odd = temp_odd;
end

endmodule