module div_16bit(
    input  wire [15:0] A,
    input  wire [7:0]  B,
    output reg  [15:0] result,
    output reg  [15:0] odd
);

reg [15:0] a_reg;
reg [7:0]  b_reg;

integer i;
reg [15:0] remainder;
reg [15:0] quotient;

always @(*) begin
    a_reg = A;
    b_reg = B;
end

always @(*) begin
    remainder = 0;
    quotient = 0;
    for(i = 15; i >= 0; i = i - 1) begin
        remainder = {remainder[14:0], a_reg[i]};
        if(remainder[7:0] >= b_reg) begin
            remainder[7:0] = remainder[7:0] - b_reg;
            quotient[i] = 1'b1;
        end else begin
            quotient[i] = 1'b0;
        end
    end
    result = quotient;
    odd = remainder;
end

endmodule