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
    reg [7:0] quotient;
    reg [15:0] remainder;
    quotient = 0;
    remainder = a_reg;
    
    for (int i = 15; i >= 8; i--) begin
        if (remainder[15:8] >= b_reg) begin
            quotient = quotient + (1 << (i - 8));
            remainder = (remainder[15:8] - b_reg) << 8 | remainder[7:0];
        end else begin
            remainder = remainder;
        end
        remainder = remainder << 1;
    end
    
    result = {8'b0, quotient};
    odd = remainder;
end

endmodule