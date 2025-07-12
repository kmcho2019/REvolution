// Module: AndGate_LUT
// Description: A 2-input AND gate implementation using a lookup table (LUT) based methodology.
module AndGate_LUT(
    input  logic a,  // First input of the AND gate
    input  logic b,  // Second input of the AND gate
    output logic out  // Output of the AND gate
);

// Define the LUT as a 2-dimensional array
logic [1:0] lut[2**2];

// Initialize the LUT with the truth table of the AND gate
initial begin
    lut[0] = 1'b0;  // a=0, b=0 -> out=0
    lut[1] = 1'b0;  // a=0, b=1 -> out=0
    lut[2] = 1'b0;  // a=1, b=0 -> out=0
    lut[3] = 1'b1;  // a=1, b=1 -> out=1
end

// Implement the LUT using a case statement
always @(*) begin
    case ({a, b})
        2'b00: out = lut[0];
        2'b01: out = lut[1];
        2'b10: out = lut[2];
        2'b11: out = lut[3];
    endcase
end

endmodule

// Module: TopModule
// Description: The top-level module that instantiates the AndGate_LUT module.
module TopModule(
    input  logic a,  // First input of the AND gate
    input  logic b,  // Second input of the AND gate
    output logic out  // Output of the AND gate
);

// Instantiate the AndGate_LUT module
AndGate_LUT and_gate_lut_instance(
   .a(a),  // Connect input 'a' to the AndGate_LUT instance
   .b(b),  // Connect input 'b' to the AndGate_LUT instance
   .out(out)  // Connect output 'out' to the AndGate_LUT instance
);

endmodule