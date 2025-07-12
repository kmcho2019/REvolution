module adder_bcd (
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

    // Binary addition of A + B + Cin
    wire [4:0] raw_sum = A + B + Cin;
    
    // Efficient detection of need for BCD correction
    // (sum > 9 or carry occurred) using binary patterns
    wire need_correction = raw_sum[4] | 
                         (raw_sum[3] & (raw_sum[2] | raw_sum[1]));
    
    // Apply correction if needed
    assign {Cout, Sum} = need_correction ? 
                        raw_sum + 5'd6 :  // Add 6 and set carry
                        {1'b0, raw_sum[3:0]}; // Pass through

endmodule