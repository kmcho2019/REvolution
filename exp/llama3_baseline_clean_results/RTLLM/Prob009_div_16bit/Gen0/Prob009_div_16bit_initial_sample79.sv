module div_16bit(
    input [15:0] A,
    input [7:0] B,
    output [15:0] result,
    output [15:0] odd
);

reg [15:0] a_reg;
reg [7:0] b_reg;
reg [15:0] temp;
reg [15:0] res;

always @(*) begin
    a_reg = A;
    b_reg = B;
end

always @(*) begin
    if (b_reg == 0) begin
        result = 16'hFFFF;
        odd = 16'h0;
    end else begin
        temp = {a_reg[15:8], 8'd0};
        res = 16'd0;
        for (int i = 7; i >= 0; i--) begin
            if (temp >= b_reg) begin
                temp = temp - b_reg;
                res = {res[14:0], 1'b1};
            end else begin
                res = {res[14:0], 1'b0};
            end
            temp = {temp[6:0], a_reg[7-i]};
        end
        result = res;
        odd = temp;
    end
end

endmodule