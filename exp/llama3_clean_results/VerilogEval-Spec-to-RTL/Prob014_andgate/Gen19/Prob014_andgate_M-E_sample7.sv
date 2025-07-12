// Module: AndGateLUT
// Description: A 2-input AND gate implemented using a lookup table.
module AndGateLUT(
    input  logic a,  // First input of the AND gate
    input  logic b,  // Second input of the AND gate
    output logic out  // Output of the AND gate
);

// Define the lookup table for the AND operation
logic [1:0] lut[3:0] = '{2'b00, 2'b00, 2'b00, 2'b01};

// Use the inputs to index into the lookup table
always @(*) begin
    // Combine inputs to create an index
    logic [1:0] index = {a, b};
    
    // Use the index to retrieve the output from the lookup table
    out = lut[index][1];
end

endmodule

// Module: TopModule
// Description: The top-level module that instantiates the AndGateLUT module.
module TopModule(
    input  logic a,  // First input of the AND gate
    input  logic b,  // Second input of the AND gate
    output logic out  // Output of the AND gate
);

// Instantiate the AndGateLUT module
AndGateLUT and_gate_lut_instance(
 .a(a),  // Connect input 'a' to the AndGateLUT instance
 .b(b),  // Connect input 'b' to the AndGateLUT instance
 .out(out)  // Connect output 'out' to the AndGateLUT instance
);

endmodule