module adder_bcd (
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

    // Compute sum and correction in one step
    wire [4:0] raw_sum = A + B + Cin;
    assign {Cout, Sum} = (raw_sum > 9) ? raw_sum + 6 : raw_sum;

endmodule