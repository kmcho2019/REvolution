module TopModule(
    input  logic a,
    input  logic b,
    output logic sum,
    output logic cout
);
// Compute the sum using XOR operation
assign sum = a ^ b;
// Compute the carry-out using AND operation
assign cout = a & b;
endmodule