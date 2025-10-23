module adder_bcd (
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

    // Prediction logic: detect cases where sum will definitely be >9
    wire A_ge5 = A[3] | (A[2] & (A[1] | A[0]));  // A >= 5
    wire B_ge5 = B[3] | (B[2] & (B[1] | B[0]));  // B >= 5
    wire sum_ge10 = (A_ge5 & B_ge5) |           // 5+5=10
                   ((A[3] | B[3]) & (A[2] | B[2])); // Either >=8 and >=4

    // Carry prediction
    wire carry_pred = sum_ge10 | 
                     ((A[3:1] == 3'b100) & (B[3:1] == 3'b100) & (A[0] | B[0] | Cin)); // 8+8=16

    // Generate both possible sums in parallel
    wire [4:0] sum_bin = A + B + Cin;
    wire [4:0] sum_corrected = sum_bin + 5'd6;

    // Select appropriate result based on prediction
    assign {Cout, Sum} = carry_pred ? sum_corrected : sum_bin;

    // Final overflow check for cases prediction might miss
    assign Cout = Cout | (Sum[3] & (Sum[2] | Sum[1])); // Handle 9+0+Cin cases
endmodule