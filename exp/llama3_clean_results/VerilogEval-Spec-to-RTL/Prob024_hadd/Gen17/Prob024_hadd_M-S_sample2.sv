// TopModule directly implements half adder logic
module TopModule(
    input  logic a,
    input  logic b,
    output logic sum,
    output logic cout
);
// Directly compute sum using XOR operation
assign sum = a ^ b;
// Directly compute carry-out using AND operation
assign cout = a & b;
endmodule