module div_16bit(
    input  [15:0] A,
    input  [7:0]  B,
    output [15:0] result,
    output [15:0] odd
);

reg [15:0] a_reg;
reg [7:0]  b_reg;
reg [15:0] result_reg;
reg [15:0] odd_reg;

assign a_reg = A;
assign b_reg = B;

integer i;
always @(*) begin
    result_reg = 0;
    odd_reg = a_reg;
    for (i = 15; i >= 0; i--) begin
        reg [7:0] temp;
        if (i >= 8) begin
            temp = odd_reg[15:8];
        end else begin
            temp = {odd_reg[15-i:8-i], 8'b0};
        end
        if (temp >= b_reg) begin
            result_reg[15-i] = 1;
            if (i >= 8) begin
                odd_reg = {temp - b_reg, odd_reg[7:0]};
            end else begin
                odd_reg = {8'b0, temp - b_reg};
            end
        end else begin
            if (i >= 8) begin
                odd_reg = {temp, odd_reg[7:0]} << 1;
            end else begin
                odd_reg = {8'b0, temp} << 1;
            end
        end
    end
    result = result_reg;
    odd = odd_reg;
end

endmodule