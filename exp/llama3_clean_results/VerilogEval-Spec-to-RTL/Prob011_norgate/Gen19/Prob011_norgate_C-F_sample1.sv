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

// Module for a NOR gate using a lookup table (LUT)
module NorGateLUT(
    input  logic a,  // Input signal a
    input  logic b,  // Input signal b
    output logic out  // Output signal out
);
    logic [1:0] lut_address;  // Address for the LUT, derived from inputs a and b.
    logic lut_out;  // Output of the LUT.

    // Combine inputs a and b to form the address for the LUT.
    assign lut_address = {a, b};

    // Define the LUT contents for the NOR gate.
    always @(*) begin
        case(lut_address)
            2'b00: lut_out = 1'b1;  // (a, b) = (0, 0), out = 1.
            2'b01: lut_out = 1'b0;  // (a, b) = (0, 1), out = 0.
            2'b10: lut_out = 1'b0;  // (a, b) = (1, 0), out = 0.
            2'b11: lut_out = 1'b0;  // (a, b) = (1, 1), out = 0.
            default: lut_out = 1'bx;  // Invalid input combination, out = unknown.
        endcase
    end

    // Assign the LUT output to the module's output.
    assign out = lut_out;
endmodule

// TopModule that allows selection between direct, modular, and LUT NOR gate implementations
module TopModule(
    input  logic a,  // Input signal a
    input  logic b,  // Input signal b
    output logic out  // Output signal out
);
    parameter implementation = 0;  // Parameter to choose implementation: 0 for direct, 1 for modular, 2 for LUT
    
    generate
        if (implementation == 0) begin
            NorGateDirect direct_nor(
               .a(a),  // Connect input a to the direct NOR gate
               .b(b),  // Connect input b to the direct NOR gate
               .out(out)  // Get the output of the direct NOR gate
            );
        end else if (implementation == 1) begin
            NorGateModular modular_nor(
               .a(a),  // Connect input a to the modular NOR gate
               .b(b),  // Connect input b to the modular NOR gate
               .out(out)  // Get the output of the modular NOR gate
            );
        end else if (implementation == 2) begin
            NorGateLUT lut_nor(
               .a(a),  // Connect input a to the LUT NOR gate
               .b(b),  // Connect input b to the LUT NOR gate
               .out(out)  // Get the output of the LUT NOR gate
            );
        end
    endgenerate
endmodule

// Example usage
module ExampleUsage(
    input  logic a,  // Input signal a
    input  logic b,  // Input signal b
    output logic direct_out,  // Output of the direct NOR gate
    output logic modular_out,  // Output of the modular NOR gate
    output logic lut_out  // Output of the LUT NOR gate
);
    TopModule direct_instance(
       .a(a),  // Connect input a to the direct instance
       .b(b),  // Connect input b to the direct instance
       .out(direct_out),  // Get the output of the direct instance
       .implementation(0)  // Select direct implementation
    );
    
    TopModule modular_instance(
       .a(a),  // Connect input a to the modular instance
       .b(b),  // Connect input b to the modular instance
       .out(modular_out),  // Get the output of the modular instance
       .implementation(1)  // Select modular implementation
    );
    
    TopModule lut_instance(
       .a(a),  // Connect input a to the LUT instance
       .b(b),  // Connect input b to the LUT instance
       .out(lut_out),  // Get the output of the LUT instance
       .implementation(2)  // Select LUT implementation
    );
endmodule