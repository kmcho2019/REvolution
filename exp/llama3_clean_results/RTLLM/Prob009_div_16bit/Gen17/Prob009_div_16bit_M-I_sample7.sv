module div_16bit(
    input clk,
    input rst,
    input [15:0] A,
    input [7:0] B,
    output reg [15:0] result,
    output reg [15:0] odd
);

reg [15:0] quotient;
reg [15:0] remainder;
reg [15:0] temp_quotient;
reg [15:0] temp_remainder;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        quotient <= 0;
        remainder <= 0;
    end else begin
        quotient <= temp_quotient;
        remainder <= temp_remainder;
    end
end

always @(*) begin
    temp_quotient = 0;
    temp_remainder = 0;

    for (int i = 15; i >= 0; i--) begin
        temp_remainder = {temp_remainder[7:0], A[i]};
        if (temp_remainder >= {8'd0, B}) begin
            temp_quotient = temp_quotient | (1 << i);
            temp_remainder = temp_remainder - {8'd0, B};
        end
    end

    result = quotient;
    odd = {8'd0, remainder[7:0]};
end

endmodule