// Module: AndGate_LUT
// Description: A 2-input AND gate implementation using a lookup table (LUT).
module AndGate_LUT(
    input  a,  // First input of the AND gate
    input  b,  // Second input of the AND gate
    output out  // Output of the AND gate
);

// Define the lookup table as a case statement within an always block
always @(*) begin
    case ({a, b})  // Use the concatenation of a and b as the case expression
        2'b00: out = 1'b0;  // For inputs 00, output is 0
        2'b01: out = 1'b0;  // For inputs 01, output is 0
        2'b10: out = 1'b0;  // For inputs 10, output is 0
        2'b11: out = 1'b1;  // For inputs 11, output is 1
        default: out = 1'b0;  // Default case, though all combinations are covered
    endcase
end

endmodule

// Module: TopModule
// Description: The top-level module that instantiates the AndGate_LUT module.
module TopModule(
    input  a,  // First input of the AND gate
    input  b,  // Second input of the AND gate
    output out  // Output of the AND gate
);

// Instantiate the AndGate_LUT module
AndGate_LUT and_gate_lut_instance(
   .a(a),  // Connect input 'a' to the AndGate_LUT instance
   .b(b),  // Connect input 'b' to the AndGate_LUT instance
   .out(out)  // Connect output 'out' to the AndGate_LUT instance
);

endmodule