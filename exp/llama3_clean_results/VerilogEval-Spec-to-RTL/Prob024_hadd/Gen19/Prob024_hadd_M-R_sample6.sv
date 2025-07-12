// TopModule directly implements XOR and AND operations for half adder functionality
module TopModule(
    input  logic a,
    input  logic b,
    output logic sum,
    output logic cout
);
// Directly implement XOR and AND operations within the TopModule
assign sum = a ^ b;
assign cout = a & b;
endmodule