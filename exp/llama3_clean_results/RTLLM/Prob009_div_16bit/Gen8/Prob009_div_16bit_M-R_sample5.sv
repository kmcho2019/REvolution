module div_16bit(
    input [15:0] A,
    input [7:0] B,
    output [15:0] result,
    output [15:0] odd
);

reg [15:0] result_reg;
reg [15:0] odd_reg;
reg [7:0] remainder;

always @(*) begin
    result_reg = 0;
    remainder = 0;
    for (int i = 15; i >= 0; i = i - 1) begin
        reg [8:0] temp;
        temp = {remainder, A[i]};
        if (temp >= {B, 1'b0}) begin
            result_reg[15 - i] = 1;
            remainder = temp - {B, 1'b0};
        end else begin
            remainder = temp;
        end
    end
    result = result_reg;
    odd = {8'd0, remainder};
end

endmodule