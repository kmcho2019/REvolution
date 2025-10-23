module TopModule(
    input in1,
    input in2,
    output out
);

// Implementing the AND gate with in2 inverted using NOR gates.
wire not_in1;
wire not_in2;
wire and_out;

// Invert in1 and in2 using NOR gates with inputs tied together.
assign not_in1 = ~(in1 | in1);
assign not_in2 = ~(in2 | in2);

// Use another NOR gate to implement the AND operation.
assign and_out = ~(not_in1 | not_in2);

// Since we want in2 inverted, we actually need the original in1 and the inverted in2.
// Thus, we correct our approach to directly implement the required logic.
assign out = ~(not_in1 | in2);

endmodule