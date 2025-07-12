module adder_bcd (
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

    // Compute initial sum with carry-out (5-bit result)
    wire [4:0] sum = A + B + Cin;
    
    // Optimized overflow detection:
    // True when either:
    // 1. Carry-out occurs (sum[4] = 1), or
    // 2. Sum[3:0] > 9 (detected as sum[3]&(sum[2]|sum[1]))
    wire overflow = sum[4] | (sum[3] & (sum[2] | sum[1]));

    // Apply correction when needed (sum + 6)
    // Implemented as single addition for clarity and efficiency
    assign Sum = overflow ? (sum[3:0] + 4'b0110) : sum[3:0];
    
    // Carry out is simply the overflow signal
    assign Cout = overflow;

endmodule