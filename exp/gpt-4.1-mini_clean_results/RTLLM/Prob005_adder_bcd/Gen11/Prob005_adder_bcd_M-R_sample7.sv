module adder_bcd(
    input  [3:0] A,
    input  [3:0] B,
    input        Cin,
    output [3:0] Sum,
    output       Cout
);

    wire [4:0] binary_sum;       // Sum of inputs and Cin (5 bits)
    wire       correction_needed;
    wire [4:0] corrected_sum;

    // Binary addition of inputs and carry in
    assign binary_sum = {1'b0, A} + {1'b0, B} + Cin;

    // Determine if correction is needed:
    // Correction is needed if sum > 9
    // Condition: sum > 9 means binary_sum > 9
    // which can be detected by binary_sum[4] == 1 or 
    // binary_sum[3] & (binary_sum[2] | binary_sum[1])
    assign correction_needed = binary_sum[4] | (binary_sum[3] & (binary_sum[2] | binary_sum[1]));

    // Correction value is 6 when needed, 0 otherwise
    wire [4:0] correction = correction_needed ? 5'd6 : 5'd0;

    // Add correction to raw binary sum
    assign corrected_sum = binary_sum + correction;

    // Final Sum and Cout outputs
    assign Sum  = corrected_sum[3:0];
    assign Cout = corrected_sum[4];

endmodule