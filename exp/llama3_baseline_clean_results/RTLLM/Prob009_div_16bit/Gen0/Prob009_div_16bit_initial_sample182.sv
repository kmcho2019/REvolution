module div_16bit(
    input  [15:0] A, // 16-bit dividend
    input  [7:0] B,  // 8-bit divisor
    output [15:0] result, // 16-bit quotient
    output [15:0] odd // 16-bit remainder
);

reg [15:0] a_reg; // register to store the dividend
reg [7:0] b_reg;  // register to store the divisor
reg [15:0] result_reg; // register to store the quotient
reg [15:0] odd_reg;    // register to store the remainder

// First always block to update the registers
always @(*)
begin
    a_reg = A; // update the dividend register
    b_reg = B; // update the divisor register
end

// Second always block to perform the division operation
always @(*)
begin
    result_reg = 0; // initialize the quotient register
    odd_reg = a_reg; // initialize the remainder register

    // Perform the division operation
    for (int i = 15; i >= 8; i--)
    begin
        if (odd_reg[15:8] >= b_reg) // compare the higher bits of the dividend with the divisor
        begin
            result_reg[i-7] = 1; // set the quotient to 1
            odd_reg = {odd_reg[7:0], odd_reg[15:8] - b_reg}; // update the remainder
        end
        else
        begin
            result_reg[i-7] = 0; // set the quotient to 0
            odd_reg = {odd_reg[7:0], odd_reg[15:8]}; // update the remainder
        end
    end

    // Assign the final values to the output ports
    result = result_reg; // assign the quotient to the output port
    odd = odd_reg;      // assign the remainder to the output port
end

endmodule