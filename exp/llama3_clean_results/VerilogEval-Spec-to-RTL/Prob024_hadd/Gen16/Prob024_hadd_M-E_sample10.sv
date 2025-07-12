// Define the TopModule using a gate-level approach
module TopModule(
    input  logic a,
    input  logic b,
    output logic sum,
    output logic cout
);
    
// Compute the sum using an XOR gate
assign sum = a ^ b;

// Compute the carry-out using an AND gate
assign cout = a & b;
endmodule