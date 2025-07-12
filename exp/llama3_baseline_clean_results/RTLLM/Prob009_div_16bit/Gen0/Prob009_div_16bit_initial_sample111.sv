module div_16bit(
    input [15:0] A,
    input [7:0] B,
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
    if (b_reg == 0) begin
        result = 16'd0;
        odd = a_reg;
    end else begin
        reg [15:0] temp;
        reg [15:0] quotient;
        reg [7:0] curr_dividend;
        quotient = 0;
        temp = a_reg;
        for (int i = 15; i >= 8; i--) begin
            curr_dividend = temp[15:8];
            if (curr_dividend >= b_reg) begin
                quotient = quotient + (1 << (i-8));
                temp = {temp[7:0], 1'b0};
                temp = temp - {b_reg, 8'd0};
            end else begin
                temp = {temp[7:0], 1'b0};
            end
        end
        odd = temp[7:0];
        result = quotient;
    end
end

endmodule