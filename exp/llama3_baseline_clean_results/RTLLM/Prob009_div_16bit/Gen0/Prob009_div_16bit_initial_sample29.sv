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
    reg [15:0] temp;
    reg [15:0] rem;
    reg [7:0] temp_b;
    result_reg = 0;
    odd_reg = 0;
    temp = {a_reg[15:8], 8'b0};
    rem = a_reg[7:0];
    temp_b = b_reg;
    for (int i = 0; i < 8; i++) begin
        if (temp >= temp_b) begin
            result_reg = result_reg + (1 << (7 - i));
            rem = temp - temp_b;
        end
        else begin
            rem = temp;
        end
        temp = {rem[7:0], a_reg[7 - i]};
    end
    odd_reg = {rem[7:0], 8'b0};
    result = result_reg;
    odd = odd_reg;
end

endmodule