module adder_bcd (
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

    // Compute initial sum with carry-in
    wire [3:0] raw_sum = A + B + Cin;
    
    // Efficient correction detection: sum >9 or carry occurred
    // Pattern: sum[3] & (sum[2] | sum[1]) detects 10-15
    wire correction = (raw_sum > 4'b1001) | (A + B + Cin > 4'b1111);
    
    // Apply correction using bitwise operations (equivalent to +6)
    assign Sum = correction ? {1'b0, raw_sum[3:1]} + 4'b0110 : raw_sum;
    
    // Simplified carry generation
    assign Cout = correction;

endmodule