module div_16bit(
    input [15:0] A,
    input [7:0] B,
    output reg [15:0] result,
    output reg [15:0] odd
);

reg [15:0] dividend;
reg [7:0] divisor;
reg [15:0] quotient;
reg [15:0] remainder;
reg [3:0] counter;

always @(*) begin
    dividend = A;
    divisor = B;
    quotient = 0;
    remainder = 0;
    counter = 0;
    
    for (int i = 0; i < 16; i++) begin
        remainder = {remainder[7:0], dividend[15-i]};
        if (remainder[15:8] >= divisor) begin
            quotient = quotient | (1 << (15-i));
            remainder = {remainder[15:8] - divisor, remainder[7:0]};
        end
    end
    
    result = quotient;
    odd = {8'd0, remainder[7:0]};
end

endmodule