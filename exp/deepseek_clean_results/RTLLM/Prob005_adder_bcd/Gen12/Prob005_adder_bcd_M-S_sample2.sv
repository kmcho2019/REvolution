module adder_bcd (
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

    // Compute raw sum including carry
    wire [4:0] raw_sum = A + B + Cin;
    
    // Detect overflow (sum > 9 or carry occurred)
    wire overflow = (raw_sum[3:0] > 4'd9) | raw_sum[4];
    
    // Apply correction (add 6 if overflow)
    assign Sum = overflow ? (raw_sum[3:0] + 4'd6) : raw_sum[3:0];
    
    // Carry out is the overflow signal
    assign Cout = overflow;

endmodule