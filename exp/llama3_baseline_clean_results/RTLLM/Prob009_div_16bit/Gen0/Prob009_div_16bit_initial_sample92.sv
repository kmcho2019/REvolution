module div_16bit (
    input wire [15:0] A,
    input wire [7:0] B,
    output wire [15:0] result,
    output wire [15:0] odd
);

reg [15:0] a_reg;
reg [7:0] b_reg;
reg [15:0] quotient;
reg [15:0] remainder;

always @(*) begin
    a_reg <= A;
    b_reg <= B;
end

always @(*) begin
    quotient = 16'b0;
    remainder = a_reg;
    
    for (int i = 15; i >= 0; i = i - 1) begin
        if (remainder[15:8] >= b_reg) begin
            quotient[15 - i] = 1'b1;
            remainder = (remainder[7:0], 1'b0) - {b_reg, 8'b0};
        end else begin
            remainder = {remainder[7:0], 1'b0};
        end
    end
    
    result = quotient;
    odd = remainder[7:0];
end

endmodule