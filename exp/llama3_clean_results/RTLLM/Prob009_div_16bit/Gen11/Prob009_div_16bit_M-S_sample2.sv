module div_16bit(
    input [15:0] A,
    input [7:0] B,
    output [15:0] result,
    output [15:0] odd
);

reg [15:0] result_reg;
reg [15:0] odd_reg;

always @(*) begin
    reg [15:0] temp_quotient;
    reg [7:0] temp_remainder;
    temp_quotient = 0;
    temp_remainder = A[15:8];
    for (int i = 7; i >= 0; i--) begin
        if (temp_remainder >= B) begin
            temp_quotient = {temp_quotient[14:0], 1'b1};
            temp_remainder = temp_remainder - B;
        end else begin
            temp_quotient = {temp_quotient[14:0], 1'b0};
        end
        temp_remainder = {temp_remainder[6:0], A[i]};
    end
    result_reg = temp_quotient;
    odd_reg = {8'd0, temp_remainder};
end

assign result = result_reg;
assign odd = odd_reg;

endmodule