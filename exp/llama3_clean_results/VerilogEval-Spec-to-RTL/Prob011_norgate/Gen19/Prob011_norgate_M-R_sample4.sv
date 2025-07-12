// Module for a basic AND gate
module AndGate(
    input  logic a,  // Input signal a
    input  logic b,  // Input signal b
    output logic out  // Output signal out
);
    assign out = a & b;  // AND operation
endmodule

// Module for a basic inverter
module Inverter(
    input  logic in,  // Input signal
    output logic out  // Output signal
);
    assign out = ~in;  // Inversion operation
endmodule

// Module for a NOR gate using AND and NOT gates
module TopModule(
    input  logic a,  // Input signal a
    input  logic b,  // Input signal b
    output logic out  // Output signal out
);
    logic not_a, not_b;  // Intermediate signals for NOT operations
    
    // Instantiate inverters for NOT A and NOT B
    Inverter inverter_a(
        .in(a),  // Input to the inverter for A
        .out(not_a)  // Output of the inverter for A
    );
    Inverter inverter_b(
        .in(b),  // Input to the inverter for B
        .out(not_b)  // Output of the inverter for B
    );
    
    // Instantiate the AND gate
    AndGate and_gate_instance(
        .a(not_a),  // Connect NOT A to the AND gate
        .b(not_b),  // Connect NOT B to the AND gate
        .out(out)  // Output of the AND gate is the final output
    );
endmodule