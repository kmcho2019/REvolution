// TopModule implementing a half adder using combinational logic
module TopModule(
    input  logic a,
    input  logic b,
    output logic sum,
    output logic cout
);
assign sum = a ^ b;  // XOR for sum
assign cout = a & b; // AND for carry-out
endmodule