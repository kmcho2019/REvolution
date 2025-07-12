module div_16bit(
    input [15:0] A,
    input [7:0] B,
    output reg [15:0] result,
    output reg [15:0] odd
);

reg [15:0] a_reg;
reg [7:0] b_reg;

// First always block to update registers with input values
always @(*) begin
    a_reg = A;
    b_reg = B;
end

// Second always block to perform the division
always @(*) begin
    reg [15:0] temp_quotient;
    reg [15:0] temp_remainder;
    temp_quotient = 0;
    temp_remainder = a_reg;
    
    for (int i = 15; i >= 8; i--) begin
        if (temp_remainder[15:8] >= b_reg) begin
            temp_quotient[15 - i] = 1;
            temp_remainder = (temp_remainder[15:8] - b_reg) << 8 | temp_remainder[7:0];
        end else begin
            temp_quotient[15 - i] = 0;
            temp_remainder = temp_remainder[15:8] << 8 | temp_remainder[7:0];
        end
    end
    
    result = {temp_quotient, 8'b0};
    odd = temp_remainder;
end

endmodule