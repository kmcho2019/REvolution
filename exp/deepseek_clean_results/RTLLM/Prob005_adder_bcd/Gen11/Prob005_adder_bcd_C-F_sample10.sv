module adder_bcd (
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

    // Compute initial sum including carry-in (5-bit result)
    wire [4:0] sum = A + B + Cin;
    
    // Parallel detection of correction need (sum >9 or carry occurred)
    wire correction_needed = (sum[3] & (sum[2] | sum[1])) | (sum > 9) | sum[4];
    
    // Apply correction (0110) when needed using efficient bitwise operation
    wire [3:0] corrected_sum = sum[3:0] + {1'b0, correction_needed, correction_needed, 1'b0};
    
    // Output assignments
    assign Sum = corrected_sum;
    assign Cout = (sum > 9) | sum[4];  // Direct from initial sum for faster carry

endmodule