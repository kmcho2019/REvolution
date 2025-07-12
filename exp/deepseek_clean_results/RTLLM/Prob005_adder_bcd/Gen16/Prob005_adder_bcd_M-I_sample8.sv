module adder_bcd (
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

    // Compute initial sum with carry-out (5-bit result)
    wire [4:0] initial_sum = A + B + Cin;
    
    // More efficient correction detection using bit pattern matching
    // Detects sum >9 or carry using: sum[4] OR (sum[3] & (sum[2] | sum[1]))
    wire correction_needed = initial_sum[4] | 
                           (initial_sum[3] & (initial_sum[2] | initial_sum[1]));
    
    // Optimized correction addition - uses direct bit manipulation
    assign Sum = correction_needed ? 
                initial_sum[3:0] + 4'b0110 : 
                initial_sum[3:0];
    
    assign Cout = correction_needed;

endmodule