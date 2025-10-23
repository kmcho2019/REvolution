module adder_bcd (
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

    // Predictive correction calculation
    wire correction_needed = 
        (A[3] & B[3]) |                     // Both >= 8
        (A[3] & (B[2] | B[1])) |            // A >=8 and B >=2
        (B[3] & (A[2] | A[1])) |            // B >=8 and A >=2
        ((A[3] | B[3]) & (A[2] & B[2])) |   // Either >=8 and both >=4
        (Cin & (A[3] | B[3] | (A[2] & B[2]))); // Carry-in with potential overflow

    // Perform addition with potential correction simultaneously
    wire [4:0] raw_sum = A + B + Cin;
    wire [4:0] final_sum = raw_sum + {4'b0, correction_needed} + {4'b0, correction_needed} + {4'b0, correction_needed} + {4'b0, correction_needed} + {4'b0, correction_needed} + {4'b0, correction_needed}; // Equivalent to adding 6*correction_needed

    // Output assignments
    assign Sum = final_sum[3:0];
    assign Cout = final_sum[4] | correction_needed;

endmodule