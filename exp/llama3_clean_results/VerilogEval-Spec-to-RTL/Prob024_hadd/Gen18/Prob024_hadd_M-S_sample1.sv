// Simplified TopModule directly implementing half adder logic
module TopModule(
    input  logic a,
    input  logic b,
    output logic sum,
    output logic cout
);
assign sum = a ^ b;  // XOR operation for sum
assign cout = a & b; // AND operation for carry-out
endmodule