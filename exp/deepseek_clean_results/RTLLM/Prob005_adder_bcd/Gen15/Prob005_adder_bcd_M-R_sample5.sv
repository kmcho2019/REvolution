module adder_bcd (
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

    // Binary sum of A + B + Cin
    wire [4:0] raw_sum = A + B + Cin;
    
    // Overflow occurs if raw sum > 9 or if carry occurred
    wire overflow = (raw_sum[3:0] > 4'd9) || raw_sum[4];
    
    // Apply correction if overflow occurred
    assign Sum = overflow ? (raw_sum[3:0] + 4'd6) : raw_sum[3:0];
    
    // Carry out is set when overflow occurs
    assign Cout = overflow;

endmodule