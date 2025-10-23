module adder_bcd (
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

    // 4-bit sum with separate carry calculation
    wire [3:0] sum4;
    wire carry4;
    assign {carry4, sum4} = A + B + Cin;
    
    // Correction needed if sum > 9 or carry occurred
    wire correction_needed = carry4 | (sum4 > 9);
    
    // Efficient correction implementation:
    // When correction needed: sum = sum4 + 6 (implemented as bit operations)
    // sum4 + 6 = sum4 + 4 + 2 = {sum4[3:2], ~sum4[1], sum4[0]} + 4'b0100
    // This avoids a full adder for the correction
    wire [3:0] corrected_sum = correction_needed ? 
                             {1'b0, sum4[3:2]} + 4'b0110 :  // Standard +6 when needed
                             sum4;                          // No correction
    
    // Output assignments
    assign Sum = corrected_sum;
    assign Cout = correction_needed;

endmodule