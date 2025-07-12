module adder_bcd (
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

    // Combined binary sum and correction calculation
    wire [4:0] raw_sum = A + B + Cin;
    
    // Efficient overflow detection (true when sum >9 or carry generated)
    // Pattern: 1xxx (carry) or x11x (8+4) or x1x1 (8+1 or 4+1) with x1x1 covering 9 case
    wire needs_correction = raw_sum[4] | 
                          (raw_sum[3] & (raw_sum[2] | raw_sum[1]));
    
    // Apply correction (either +0 or +6) using the same adder
    assign {Cout, Sum} = raw_sum + (needs_correction ? 5'd6 : 5'd0);

endmodule