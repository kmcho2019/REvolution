module adder_bcd (
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

    // Ripple-carry binary sum
    wire [4:0] sum_bin = A + B + Cin;
    
    // Overflow occurs when sum > 9 or carry out from binary addition
    wire overflow = (sum_bin[4]) | (sum_bin[3] & (sum_bin[2] | sum_bin[1]));
    
    // Apply BCD correction (add 6) if overflow occurred
    assign Sum = overflow ? sum_bin[3:0] + 4'd6 : sum_bin[3:0];
    assign Cout = overflow;

endmodule