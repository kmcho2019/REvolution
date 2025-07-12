module TopModule (
    input x3,
    input x2,
    input x1,
    output f
);
    // 8-bit LUT containing the truth table outputs (MSB first)
    parameter [7:0] LUT = 8'b00110101;
    
    // Convert inputs to index (0-7)
    wire [2:0] index = {x3, x2, x1};
    
    // Output the corresponding bit from LUT
    assign f = LUT[index];
endmodule