// Superior Module TopModule implementing a NOR gate with flexibility.
module TopModule(
    input  logic a,  // Input signal a
    input  logic b,  // Input signal b
    output logic out  // Output signal out
);

// Parameter to choose between direct implementation and basic gate implementation.
parameter implementation_type = "direct";  // "direct" or "basic_gates"

// Direct implementation of NOR gate.
wire out_direct;  // Output for direct implementation
assign out_direct = ~(a | b);  // NOR operation directly implemented

// Basic gate implementation of NOR gate.
wire a_inv;  // Inverted input a
wire b_inv;  // Inverted input b
wire out_basic;  // Output for basic gate implementation
assign a_inv = ~a;  // Invert input a
assign b_inv = ~b;  // Invert input b
assign out_basic = a_inv & b_inv;  // NOR operation using AND gate on inverted inputs

// Choose output based on implementation type.
assign out = (implementation_type == "direct")? out_direct : out_basic;

endmodule