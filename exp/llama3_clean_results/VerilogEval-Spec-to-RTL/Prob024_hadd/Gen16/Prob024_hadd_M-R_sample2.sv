// TopModule implementing half adder functionality directly
module TopModule(
    input  logic a,
    input  logic b,
    output logic sum,
    output logic cout
);
assign sum = a ^ b; // XOR for sum
assign cout = a & b; // AND for carry-out
endmodule