// TopModule integrates the half-adder logic directly
module TopModule(
    input  logic a,
    input  logic b,
    output logic sum,
    output logic cout
);
assign sum = a ^ b;  // Directly implement XOR for sum
assign cout = a & b; // Directly implement AND for carry-out
endmodule