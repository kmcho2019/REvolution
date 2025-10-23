// Define the TopModule with optimized logic
module TopModule(
    input  logic a,
    input  logic b,
    output logic sum,
    output logic cout
);
// Directly compute sum and cout using XOR and AND operations
assign sum = a ^ b;
assign cout = a & b;
endmodule

// Alternative implementation using a combined logic expression
module TopModule_Optimized(
    input  logic a,
    input  logic b,
    output logic sum,
    output logic cout
);
// Compute sum and cout using a single logic expression
assign {cout, sum} = a + b;
endmodule