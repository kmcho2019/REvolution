// Module TopModule implements an XNOR gate using a multiplexer (MUX)
// The XNOR operation outputs 1 when both inputs are the same (either both 0 or both 1), and outputs 0 otherwise
module TopModule(
    input a,  // Input signal a
    input b,  // Input signal b
    output out // Output signal out
);

// Internal wires
wire sel;  // Selection signal for the MUX
wire data0, data1;  // Data inputs for the MUX

// Derive the selection signal (sel) based on the inputs
assign sel = a & b;  // sel is 1 when both a and b are 1

// Derive the data inputs for the MUX
assign data0 = 1'b1;  // Data input when sel is 0 (both inputs are the same)
assign data1 = 1'b0;  // Data input when sel is 1 (both inputs are different)

// Implement the MUX
assign out = sel ? data1 : data0;

endmodule