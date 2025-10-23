module adder_bcd (
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

    wire [4:0] sum = A + B + Cin;
    assign {Cout, Sum} = (sum > 9) ? (sum + 6) : sum;
    
endmodule