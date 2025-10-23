module div_16bit(
    input  [15:0] A,  // 16-bit dividend
    input  [7:0] B,   // 8-bit divisor
    output [15:0] result,  // 16-bit quotient
    output [15:0] odd     // 16-bit remainder
);

reg [15:0] a_reg;  // register for dividend
reg [7:0] b_reg;   // register for divisor
reg [15:0] result_reg;  // register for quotient
reg [15:0] odd_reg;     // register for remainder

// Combinational block to update a_reg and b_reg
always @(*) begin
    a_reg = A;
    b_reg = B;
end

// Combinational block to perform division operation
always @(*) begin
    result_reg = 0;
    odd_reg = a_reg;
    
    for (int i = 15; i >= 8; i--) begin
        if (odd_reg[15:8] >= b_reg) begin
            result_reg[i] = 1;
            odd_reg = (odd_reg[14:0], 1'b0) - {b_reg, 8'b0};
        end else begin
            result_reg[i] = 0;
            odd_reg = {odd_reg[14:0], 1'b0};
        end
    end
    
    // Store the final remainder in odd_reg
    odd_reg = {8'b0, odd_reg[7:0]};
    
    // Assign the result and odd values to output ports
    result = result_reg;
    odd = odd_reg;
end

endmodule