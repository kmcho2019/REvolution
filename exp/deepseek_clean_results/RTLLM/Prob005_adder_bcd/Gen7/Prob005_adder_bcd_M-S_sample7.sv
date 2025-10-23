module adder_bcd (
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

    wire [4:0] sum_temp = A + B + Cin;
    wire overflow = (sum_temp > 9) | (sum_temp[4]);
    
    assign Sum = overflow ? (sum_temp[3:0] + 4'd6) : sum_temp[3:0];
    assign Cout = overflow;

endmodule