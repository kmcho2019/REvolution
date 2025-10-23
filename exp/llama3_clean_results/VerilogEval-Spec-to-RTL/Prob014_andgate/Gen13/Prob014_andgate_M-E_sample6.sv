// Module: TopModule
// Description: A parameterized N-input AND gate implementation using recursive module instantiation.
module TopModule(
    input  a,  // First input of the AND gate
    input  b,  // Second input of the AND gate
    output out  // Output of the AND gate
);

// Define a parameter for the number of inputs (fixed to 2 for this specific problem)
parameter NUM_INPUTS = 2;

// Define a helper module for a 2-input AND gate
module AndGate2(
    input  a,
    input  b,
    output out
);
    assign out = a & b;
endmodule

// Define a helper module for an N-input AND gate
module AndGateN(
    input  [NUM_INPUTS-1:0] in,
    output out
);
    wire [NUM_INPUTS/2-1:0] mid;
    generate
        if (NUM_INPUTS == 1) begin
            assign out = in[0];
        end else if (NUM_INPUTS == 2) begin
            AndGate2 and_gate2(
               .a(in[0]),
               .b(in[1]),
               .out(out)
            );
        end else begin
            AndGateN and_gate_n1(
               .in(in[NUM_INPUTS/2-1:0]),
               .out(mid[0])
            );
            AndGateN and_gate_n2(
               .in(in[NUM_INPUTS-1:NUM_INPUTS/2]),
               .out(mid[1])
            );
            AndGate2 and_gate2(
               .a(mid[0]),
               .b(mid[1]),
               .out(out)
            );
        end
    endgenerate
endmodule

// Instantiate the N-input AND gate module
AndGateN and_gate_n(
   .in({a, b}),
   .out(out)
);

endmodule