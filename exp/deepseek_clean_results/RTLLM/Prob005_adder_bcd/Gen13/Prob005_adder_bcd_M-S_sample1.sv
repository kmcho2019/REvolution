module adder_bcd (
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

    // Binary addition with carry
    wire [4:0] sum_bin = A + B + Cin;
    
    // Overflow occurs if binary sum >9 or carry out from MSB
    wire overflow = (sum_bin[4]) || (sum_bin[3:0] > 4'd9);
    
    // Apply correction (+6) if overflow occurred
    assign Sum = overflow ? sum_bin[3:0] + 4'd6 : sum_bin[3:0];
    assign Cout = overflow;

endmodule