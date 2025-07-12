// Full Adder module optimized for fewer gates
module FullAdder(
    input  logic a, 
    input  logic b, 
    input  logic cin, 
    output logic sum, 
    output logic cout
);
    assign sum = a ^ b ^ cin;
    assign cout = (a & b) | (a & cin) | (b & cin);
endmodule

// TopModule with a modular structure and explicit carry signals
module TopModule(
    input  logic [3:0] x, 
    input  logic [3:0] y, 
    output logic [4:0] sum
);
    logic c1, c2, c3;

    FullAdder fa0(x[0], y[0], 1'b0, sum[0], c1);
    FullAdder fa1(x[1], y[1], c1, sum[1], c2);
    FullAdder fa2(x[2], y[2], c2, sum[2], c3);
    FullAdder fa3(x[3], y[3], c3, sum[3], sum[4]);
endmodule