// TopModule directly implements half adder functionality
// It takes two inputs (a and b), and produces two outputs (sum and cout)
module TopModule(
    input  logic a,
    input  logic b,
    output logic sum,
    output logic cout
);
// Calculate sum using XOR operation
assign sum = a ^ b;
// Calculate carry-out using AND operation
assign cout = a & b;
endmodule