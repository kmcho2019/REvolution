module adder_bcd (
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

    // Intermediate signals
    wire [3:0] raw_sum;
    wire carry_out;
    wire needs_correction;
    
    // Compute raw sum (4-bit + 4-bit + 1-bit = 5-bit result)
    wire [4:0] full_sum = A + B + Cin;
    
    // Extract 4-bit sum and carry
    assign raw_sum = full_sum[3:0];
    assign carry_out = full_sum[4];
    
    // Determine if correction needed (sum > 9 or carry generated)
    assign needs_correction = (raw_sum > 4'd9) | carry_out;
    
    // Apply correction if needed (add 6)
    assign Sum = needs_correction ? raw_sum + 4'd6 : raw_sum;
    
    // Carry out is set when correction is needed
    assign Cout = needs_correction;

endmodule