// Module for a basic OR gate
module OrGate(
    input  logic a,  // Input signal a
    input  logic b,  // Input signal b
    output logic out  // Output signal out
);
    assign out = a | b;  // OR operation
endmodule

// Module for a basic inverter
module Inverter(
    input  logic in,  // Input signal
    output logic out  // Output signal
);
    assign out = ~in;  // Inversion operation
endmodule

// Module for a NOR gate using the logical NOR operator directly
module NorGateDirect(
    input  logic a,  // Input signal a
    input  logic b,  // Input signal b
    output logic out  // Output signal out
);
    assign out = ~(a | b);  // Direct NOR operation using logical NOR operator
endmodule

// Module for a NOR gate using an OR gate and an inverter
module NorGateModular(
    input  logic a,  // Input signal a
    input  logic b,  // Input signal b
    output logic out  // Output signal out
);
    logic or_out;  // Intermediate signal for OR gate output
    
    // Instantiate the OR gate
    OrGate or_gate_instance(
        .a(a),  // Connect input a to the OR gate
        .b(b),  // Connect input b to the OR gate
        .out(or_out)  // Get the output of the OR gate
    );
    
    // Instantiate the inverter
    Inverter inverter_instance(
        .in(or_out),  // Input to the inverter is the output of the OR gate
        .out(out)  // Output of the inverter is the final output
    );
endmodule

// Simplified TopModule using direct NOR gate implementation
module TopModule(
    input  logic a,  // Input signal a
    input  logic b,  // Input signal b
    output logic out  // Output signal out
);
    assign out = ~(a | b);  // Direct NOR operation
endmodule