// TopModule implements a half adder directly using XOR and AND operators
module TopModule(
    input  logic a,
    input  logic b,
    output logic sum,
    output logic cout
);
assign sum = a ^ b; // XOR for sum
assign cout = a & b; // AND for carry-out
endmodule