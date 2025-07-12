// TopModule: An optimized 2-input AND gate
module TopModule(
    input  logic a,  // First input of the AND gate
    input  logic b,  // Second input of the AND gate
    output logic out // Output of the AND gate
);

// To optimize for high-speed implementations, consider using synthesis options
// that favor high-speed library cells or technology nodes.
// For low-power optimization, explore synthesis options or technology libraries
// that favor low-power implementations.

// Continuous assignment for combinational logic
// This approach is efficient for describing the AND gate's logic.
assign out = a & b; // Perform AND operation and assign to out

// When synthesizing, consider the PPA metrics and explore different synthesis
// tools or target technologies to minimize area and power consumption while
// maintaining the required functionality.

endmodule