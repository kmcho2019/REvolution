// Define the module TopModule with input ports a and b, and output port q.
module TopModule(
    input  logic a, // Declare as logic for clarity and modern Verilog practice
    input  logic b, // Declare as logic for clarity and modern Verilog practice
    output logic q  // Declare as logic for clarity and modern Verilog practice
);

// Use an always_comb block to define the combinational logic.
always_comb begin
    // The module implements a simple AND gate, setting q to 1 only when both a and b are 1.
    q = a & b; // Direct and efficient AND operation
end

endmodule