module adder_bcd (
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

    // Binary addition
    wire [4:0] binary_sum = A + B + Cin;
    
    // Overflow detection (sum >9 or carry out)
    wire overflow = (binary_sum[4]) | 
                   (binary_sum[3] & (binary_sum[2] | binary_sum[1]));
    
    // Pre-compute both possible results
    wire [3:0] sum_uncorrected = binary_sum[3:0];
    wire [3:0] sum_corrected = sum_uncorrected + 4'd6;
    
    // Output selection
    assign Sum = overflow ? sum_corrected : sum_uncorrected;
    assign Cout = overflow;

endmodule