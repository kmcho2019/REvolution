// Module: TopModule
// Description: A 2-input AND gate implementation using a multiplexer (MUX) based methodology.
module TopModule(
    input  logic a,  // First input of the AND gate
    input  logic b,  // Second input of the AND gate
    output logic out  // Output of the AND gate
);

// Use a MUX to select between two inputs
logic mux_out;
assign mux_out = (a == 1'b1)? b : 1'b0;

// Assign the MUX output to the output of the AND gate
assign out = mux_out;

endmodule