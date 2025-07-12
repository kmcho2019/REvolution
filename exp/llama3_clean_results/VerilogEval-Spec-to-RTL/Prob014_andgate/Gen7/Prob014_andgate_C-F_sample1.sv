// TopModule: A 2-input AND gate implemented using a continuous assignment for simplicity and clarity.
module TopModule(
    input  a,  // First input of the AND gate.
    input  b,  // Second input of the AND gate.
    output out  // Output of the AND gate.
);

// Use a continuous assignment to directly convey the intention of the design as a simple combinational circuit.
assign out = a & b;  // Perform the AND operation and assign the result to out.

endmodule