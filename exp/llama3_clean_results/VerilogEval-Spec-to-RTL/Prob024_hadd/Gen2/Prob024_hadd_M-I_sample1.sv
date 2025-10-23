module TopModule(
    input  logic a, // Explicitly define input logic
    input  logic b,
    output logic sum, // Explicitly define output logic
    output logic cout
);

assign sum = a ^ b; // XOR operation for sum
assign cout = a & b; // AND operation for carry-out

endmodule