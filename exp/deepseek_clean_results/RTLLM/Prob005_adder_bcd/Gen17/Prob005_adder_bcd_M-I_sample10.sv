module adder_bcd (
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

    // Compute initial sum with carry-out (5-bit)
    wire [4:0] sum_ext = A + B + Cin;
    
    // Optimized overflow detection using pattern matching
    // Detects when sum[3:0] > 9 (1001) or carry-out occurs
    wire overflow = (sum_ext[3:0] > 4'd9) | sum_ext[4];

    // Corrected sum is either:
    // 1. Original sum + 6 (when overflow)
    // 2. Original sum (when no overflow)
    wire [3:0] corrected_sum = sum_ext[3:0] + 4'd6;
    
    // Select between original and corrected sum
    assign Sum = overflow ? corrected_sum : sum_ext[3:0];
    assign Cout = overflow;

endmodule