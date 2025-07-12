// Improved TopModule with direct XOR and AND operations for half adder functionality
module TopModule(
    input  logic a,
    input  logic b,
    output logic sum,
    output logic cout
);
// Direct XOR operation for sum
assign sum = a ^ b;
// Direct AND operation for carry-out
assign cout = a & b;
endmodule