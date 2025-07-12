module adder_bcd (
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

    // Early overflow prediction (based on input patterns)
    wire A_ge5 = A[3] | (A[2] & (A[1] | A[0]));
    wire B_ge5 = B[3] | (B[2] & (B[1] | B[0]));
    wire sum_ge10 = (A_ge5 & B_ge5) |  // Both >=5
                   ((A[3] | B[3]) & (A[2] | B[2]);  // Either >=8
    
    // Parallel computation paths
    wire [4:0] sum_binary = A + B + Cin;
    wire [4:0] sum_corrected = sum_binary + 5'd6;  // Pre-compute corrected sum
    
    // Final selection logic
    wire need_correction = sum_ge10 | (sum_binary > 9);
    assign Sum = need_correction ? sum_corrected[3:0] : sum_binary[3:0];
    assign Cout = need_correction | sum_binary[4];
    
endmodule