module div_16bit(
    input  [15:0] A,
    input  [7:0]  B,
    output reg [15:0] result,
    output reg [15:0] odd
);

reg [15:0] a_reg;
reg [7:0]  b_reg;

always @(*) begin
    a_reg = A;
    b_reg = B;
end

always @(*) begin
    result = 0;
    odd = a_reg;
    for (int i = 15; i >= 0; i--) begin
        reg [7:0] temp;
        if (i >= 8) begin
            temp = odd[15:8];
        end else begin
            temp = {odd[15-i:8-i], 8'b0};
        end
        if (temp >= b_reg) begin
            result[15-i] = 1;
            odd = (i >= 8)? ({temp - b_reg, odd[7:0]}) : ({8'b0, temp - b_reg});
        end else begin
            odd = (i >= 8)? ({temp, odd[7:0]} << 1) : ({8'b0, temp} << 1);
        end
    end
end

endmodule