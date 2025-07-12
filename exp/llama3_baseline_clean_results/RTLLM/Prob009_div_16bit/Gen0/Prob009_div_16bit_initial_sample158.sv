module div_16bit (
    input   [15:0] A,  // 16-bit dividend
    input   [7:0]  B,  // 8-bit divisor
    output  [15:0] result,  // 16-bit quotient
    output  [15:0] odd     // 16-bit remainder
);

reg [15:0] a_reg;
reg [7:0]  b_reg;
reg [15:0] result_reg;
reg [15:0] odd_reg;

// Combinational block to update registers
always @(*) begin
    a_reg = A;
    b_reg = B;
end

// Combinational block to perform division
always @(*) begin
    reg [15:0] temp;
    reg [7:0]  divisor;
    reg [15:0] quotient;
    reg [15:0] remainder;

    divisor = b_reg;
    quotient = 0;
    remainder = a_reg;

    for (int i = 15; i >= 0; i = i - 1) begin
        if (remainder[15:8] >= divisor) begin
            quotient = {quotient[14:0], 1'b1};
            remainder = {remainder[14:0], 1'b0} - {divisor, 8'b0};
        end else begin
            quotient = {quotient[14:0], 1'b0};
            remainder = {remainder[14:0], 1'b0};
        end
    end

    result_reg = quotient;
    odd_reg = remainder;
end

assign result = result_reg;
assign odd = odd_reg;

endmodule