// TopModule with integrated XOR and AND operations for half adder functionality
module TopModule(
    input  logic a,
    input  logic b,
    output logic sum,
    output logic cout
);
assign sum = a ^ b;
assign cout = a & b;
endmodule