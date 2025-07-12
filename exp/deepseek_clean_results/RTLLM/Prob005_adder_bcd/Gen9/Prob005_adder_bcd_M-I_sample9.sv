module adder_bcd (
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

    wire [4:0] sum = A + B + Cin;
    wire correction = sum[4] | (sum[3] & (sum[2] | sum[1]));
    
    assign {Cout, Sum} = sum + (correction ? 5'd6 : 5'd0);
    
endmodule