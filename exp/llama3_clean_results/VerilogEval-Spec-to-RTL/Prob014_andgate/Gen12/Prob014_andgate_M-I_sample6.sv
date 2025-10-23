// TopModule: An optimized 2-input AND gate
module TopModule(
    input  logic a,  // First input of the AND gate
    input  logic b,  // Second input of the AND gate
    output logic out // Output of the AND gate
);

// Continuous assignment for combinational logic
assign out = a & b; // Perform AND operation and assign to out

endmodule