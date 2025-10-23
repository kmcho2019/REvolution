module adder_bcd (
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

    // Binary addition
    wire [4:0] sum_temp = A + B + Cin;
    
    // Overflow detection (sum >9)
    wire overflow = (sum_temp[4]) || (sum_temp[3] && (sum_temp[2] || sum_temp[1]));
    
    // Conditional correction and final sum
    assign Sum = overflow ? (sum_temp[3:0] + 4'd6) : sum_temp[3:0];
    assign Cout = overflow;

endmodule