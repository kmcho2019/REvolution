module adder_bcd (
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

    // Binary addition with carry
    wire [4:0] sum_temp = A + B + Cin;
    
    // Detect if sum >9 or carry occurred
    wire overflow = (sum_temp[4]) || (sum_temp[3:0] > 4'd9);
    
    // Apply correction if needed
    assign Sum = overflow ? (sum_temp[3:0] + 4'd6) : sum_temp[3:0];
    assign Cout = overflow;

endmodule