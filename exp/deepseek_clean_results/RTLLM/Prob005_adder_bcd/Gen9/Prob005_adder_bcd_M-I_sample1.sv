module adder_bcd (
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

    // Compute both possible sums in parallel
    wire [4:0] raw_sum = A + B + Cin;
    wire [4:0] corrected_sum = raw_sum + 5'd6;
    
    // Efficient overflow detection (sum >9 or carry)
    // Pattern matches when:
    // - MSB set (carry) OR
    // - Bit 3 and (bit 2 or bit 1) set (values 10-15)
    wire needs_correction = raw_sum[4] | 
                          (raw_sum[3] & (raw_sum[2] | raw_sum[1]));
    
    // Select appropriate sum and carry
    assign {Cout, Sum} = needs_correction ? corrected_sum : raw_sum;

endmodule