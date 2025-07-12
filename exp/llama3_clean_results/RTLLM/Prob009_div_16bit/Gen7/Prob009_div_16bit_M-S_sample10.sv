module div_16bit(
    input [15:0] A,
    input [7:0] B,
    output reg [15:0] result,
    output reg [15:0] odd
);

always @(*) begin
    reg [15:0] temp_quotient;
    reg [15:0] temp_remainder;
    temp_quotient = 0;
    temp_remainder = A;

    for (int i = 15; i >= 0; i--) begin
        temp_remainder = {temp_remainder[7:0], 1'b0};
        if (temp_remainder[15:8] >= B) begin
            temp_quotient = temp_quotient | (1 << i);
            temp_remainder = {temp_remainder[15:8] - B, temp_remainder[7:0]};
        end
    end

    result = temp_quotient;
    odd = {8'd0, temp_remainder[7:0]};
end

endmodule