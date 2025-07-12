// Novel Module TopModule implementing a NOR gate using NOT and AND gates.
module TopModule(
    input  a,  // Input signal a
    input  b,  // Input signal b
    output out  // Output signal out
);

// Internal wires to hold inverted inputs
wire a_inv;  // Inverted input a
wire b_inv;  // Inverted input b

// Invert input signals
assign a_inv = ~a;  // Invert input a
assign b_inv = ~b;  // Invert input b

// Implement NOR gate using AND operation on inverted inputs
assign out = a_inv & b_inv;  // NOR operation using AND gate

endmodule