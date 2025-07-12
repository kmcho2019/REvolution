// TopModule directly implements half adder functionality using XOR and AND operations
module TopModule(
    input  logic a,
    input  logic b,
    output logic sum,
    output logic cout
);
assign sum = a ^ b;
assign cout = a & b;
endmodule