module adder_bcd (
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

    // Compute binary sum in parallel with carry lookahead
    wire [3:0] binary_sum = A + B + Cin;
    
    // Optimized overflow detection (sum > 9)
    wire overflow = (binary_sum[3] & (binary_sum[2] | binary_sum[1])) | (binary_sum > 9);
    
    // Pre-compute both possible sums (corrected and uncorrected)
    wire [3:0] sum_corrected = binary_sum + 4'd6;
    
    // Select appropriate sum based on overflow
    assign Sum = overflow ? sum_corrected : binary_sum;
    assign Cout = overflow;

endmodule