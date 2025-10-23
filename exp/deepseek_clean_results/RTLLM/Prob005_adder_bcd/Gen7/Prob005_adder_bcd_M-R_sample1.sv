module adder_bcd (
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

    // First compute binary sum of A+B+Cin
    wire [4:0] binary_sum = A + B + Cin;
    
    // Overflow occurs when either:
    // 1. Binary sum exceeds 15 (carry out from MSB)
    // 2. Sum is between 10-15 (invalid BCD)
    wire overflow = (binary_sum > 9) | binary_sum[4];
    
    // Select between raw sum (when <=9) or corrected sum (+6)
    assign Sum = overflow ? (binary_sum[3:0] + 4'd6) : binary_sum[3:0];
    assign Cout = overflow;

endmodule