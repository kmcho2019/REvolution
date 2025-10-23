module adder_bcd (
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

    // Intermediate sum including carry (5-bit)
    wire [4:0] raw_sum = A + B + Cin;
    
    // Overflow detection (sum > 9)
    wire overflow = (raw_sum[4]) ||                // Sum >= 16
                    (raw_sum[3] & raw_sum[2]) ||   // 12-15
                    (raw_sum[3] & raw_sum[1]);      // 10-11
    
    // Correction value (6 when overflow, 0 otherwise)
    wire [3:0] correction = overflow ? 4'b0110 : 4'b0000;
    
    // Final sum after possible correction
    wire [3:0] corrected_sum = raw_sum[3:0] + correction;
    
    // Output assignments
    assign Sum = corrected_sum;
    assign Cout = overflow;

endmodule