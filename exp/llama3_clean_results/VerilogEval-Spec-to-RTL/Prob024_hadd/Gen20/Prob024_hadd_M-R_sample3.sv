// Refactored TopModule implementing half adder functionality directly
module TopModule(
    input  logic a,
    input  logic b,
    output logic sum,
    output logic cout
);
// Directly assign sum and carry-out using XOR and AND operations
assign sum = a ^ b;
assign cout = a & b;
endmodule