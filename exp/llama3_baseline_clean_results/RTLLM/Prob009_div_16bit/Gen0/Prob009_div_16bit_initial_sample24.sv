module div_16bit (
    input   [15:0] A,  // 16-bit dividend
    input   [7:0]  B,  // 8-bit divisor
    output  [15:0] result,  // 16-bit quotient
    output  [15:0] odd     // 16-bit remainder
);

reg [15:0] a_reg;
reg [7:0] b_reg;

always @(*) begin
    a_reg = A;
    b_reg = B;
end

reg [15:0] temp_quotient;
reg [15:0] temp_remainder;

always @(*) begin
    temp_quotient = 0;
    temp_remainder = a_reg;
    
    for (int i = 15; i >= 8; i--) begin
        reg [15:0] temp;
        temp = {temp_remainder[15:8], 8'd0};
        
        if (temp >= b_reg) begin
            temp_quotient = temp_quotient << 1;
            temp_quotient[0] = 1;
            temp_remainder = temp - b_reg;
        end else begin
            temp_quotient = temp_quotient << 1;
            temp_remainder = {temp_remainder[7:0], temp_remainder[15:8]};
        end
    end
    
    for (int i = 7; i >= 0; i--) begin
        reg [15:0] temp;
        temp = {temp_remainder[15:1], 1'd0};
        
        if (temp >= b_reg) begin
            temp_quotient = temp_quotient << 1;
            temp_quotient[0] = 1;
            temp_remainder = temp - b_reg;
        end else begin
            temp_quotient = temp_quotient << 1;
            temp_remainder = {temp_remainder[7:0], temp_remainder[15]};
        end
    end
    
    result = temp_quotient;
    odd = temp_remainder;
end

endmodule