module adder_bcd (
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

    // Compute raw sum and carry
    wire [4:0] raw_sum = A + B + Cin;
    
    // Compute corrected sum (raw_sum + 6)
    wire [4:0] corrected_sum = raw_sum + 5'd6;
    
    // Overflow occurs if raw sum >9 or carry out
    wire overflow = (raw_sum[4]) || (raw_sum[3] && (raw_sum[2] || raw_sum[1]));
    
    // Select appropriate sum and carry
    assign Sum = overflow ? corrected_sum[3:0] : raw_sum[3:0];
    assign Cout = overflow;
    
endmodule