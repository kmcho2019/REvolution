module adder_bcd (
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

    // Compute 5-bit sum including carry-out
    wire [4:0] raw_sum = A + B + Cin;
    
    // Optimized overflow detection:
    // - Check if raw_sum[4] is set (sum >= 16)
    // - OR if any of the upper bits make sum > 9 (1001)
    wire overflow = raw_sum[4] | 
                  (raw_sum[3] & (raw_sum[2] | raw_sum[1]));

    // Apply correction when needed
    assign Sum = overflow ? (raw_sum[3:0] + 4'd6) : raw_sum[3:0];
    
    // Carry output is same as overflow condition
    assign Cout = overflow;

endmodule