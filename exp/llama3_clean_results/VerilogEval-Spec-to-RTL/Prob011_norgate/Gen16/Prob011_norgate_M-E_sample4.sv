// Novel module TopModule implements a NOR gate using basic logic gates.
module TopModule(
    input  logic a,  // Input signal a
    input  logic b,  // Input signal b
    output logic out  // Output signal out
);

// Internal wires to connect the NOT gates and the AND gate.
logic not_a;  // Inverted input a
logic not_b;  // Inverted input b

// NOT gates to invert inputs a and b.
assign not_a = ~a;  // Invert input a
assign not_b = ~b;  // Invert input b

// AND gate to produce the final output.
assign out = not_a & not_b;  // AND the inverted inputs to get the NOR output

endmodule