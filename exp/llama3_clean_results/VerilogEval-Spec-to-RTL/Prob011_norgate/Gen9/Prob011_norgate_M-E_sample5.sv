// Novel Module TopModule implementing a NOR gate using basic logic gates.
module TopModule(
    input  a,  // Input signal a
    input  b,  // Input signal b
    output out  // Output signal out
);

// Internal wires for inverted inputs.
wire a_inv;  // Inverted input a
wire b_inv;  // Inverted input b

// Invert inputs.
assign a_inv = ~a;  // Invert input a
assign b_inv = ~b;  // Invert input b

// Implement NOR using inverted inputs and AND gate.
assign out = a_inv & b_inv;  // NOR operation using AND gate on inverted inputs

endmodule