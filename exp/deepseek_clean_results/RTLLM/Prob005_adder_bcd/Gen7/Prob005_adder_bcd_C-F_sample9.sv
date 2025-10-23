module adder_bcd (
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

    // Compute initial sum with carry-out (5-bit result)
    wire [4:0] initial_sum = A + B + Cin;
    
    // Detect need for correction using both carry and value >9
    // Optimized as: carry OR (sum[3] AND (sum[2] OR sum[1]))
    wire correction_needed = (initial_sum > 9) | initial_sum[4];
    
    // Apply correction in parallel with carry generation
    assign Sum = initial_sum[3:0] + {1'b0, correction_needed, correction_needed, 1'b0}; // +6 when needed
    assign Cout = correction_needed;

endmodule