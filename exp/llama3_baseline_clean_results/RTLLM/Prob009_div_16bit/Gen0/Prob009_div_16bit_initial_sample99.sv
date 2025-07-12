module div_16bit(
    input [15:0] A, // 16-bit dividend
    input [7:0] B,  // 8-bit divisor
    output reg [15:0] result, // 16-bit quotient
    output reg [15:0] odd // 16-bit remainder
);

reg [15:0] a_reg; // Register for dividend
reg [7:0] b_reg;  // Register for divisor
reg [15:0] temp;  // Temporary register for remainder
reg [15:0] quot;  // Register for quotient

// First always block to update input registers
always @(*) begin
    a_reg = A;
    b_reg = B;
end

// Second always block to perform division
always @(*) begin
    temp = {a_reg[15:8], 8'd0}; // Extract higher bits of dividend and pad with zeros
    quot = 0; // Initialize quotient
    for (int i = 8; i >= 0; i = i - 1) begin // Iterate over remaining bits
        if (temp >= b_reg) begin // Compare extracted bits with divisor
            temp = temp - b_reg; // Update remainder
            quot = quot | (1 << i); // Update quotient
        end
        temp = {temp[7:0], a_reg[7 - i]}; // Shift remainder and add next bit of dividend
    end
    result = quot; // Assign quotient to output
    odd = temp[7:0]; // Assign remainder to output, zero extending to 16 bits
end

endmodule