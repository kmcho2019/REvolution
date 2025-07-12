// Module TopModule implements an XNOR gate using a multiplexer
// The XNOR operation outputs 1 when both inputs are the same (either both 0 or both 1), and outputs 0 otherwise
module TopModule(
    input a,  // Input signal a
    input b,  // Input signal b
    output out // Output signal out
);

// Internal wires
wire sel;  // Selection signal for the multiplexer
wire data0;  // First data input to the multiplexer
wire data1;  // Second data input to the multiplexer

// Derive selection signal from input a
assign sel = a;

// Set data0 and data1 for XNOR operation
assign data0 = ~b;  // When sel is 0, output should be ~b
assign data1 = b;   // When sel is 1, output should be b

// Use a 2-to-1 multiplexer to select the output
assign out = (sel) ? data1 : data0;

endmodule