// Module: NandGate
// Description: A basic 2-input NAND gate implementation.
module NandGate(
    input  logic a,  // First input of the NAND gate
    input  logic b,  // Second input of the NAND gate
    output logic out  // Output of the NAND gate
);

// Implement a 2-input NAND gate
assign out = ~(a & b);

endmodule

// Module: Inverter
// Description: A basic inverter implementation.
module Inverter(
    input  logic in,  // Input to the inverter
    output logic out  // Output of the inverter
);

// Implement an inverter
assign out = ~in;

endmodule

// Module: TopModule
// Description: The top-level module that implements an AND gate using a NAND gate and an inverter.
module TopModule(
    input  logic a,  // First input of the AND gate
    input  logic b,  // Second input of the AND gate
    output logic out  // Output of the AND gate
);

// Instantiate the NandGate module
logic nand_out;  // Internal signal for the NAND gate output
NandGate nand_gate_instance(
  .a(a),  // Connect input 'a' to the NandGate instance
  .b(b),  // Connect input 'b' to the NandGate instance
  .out(nand_out)  // Connect output of NandGate to internal signal
);

// Instantiate the Inverter module
Inverter inverter_instance(
  .in(nand_out),  // Connect the output of the NAND gate to the inverter
  .out(out)  // Connect the output of the inverter to the TopModule output
);

endmodule