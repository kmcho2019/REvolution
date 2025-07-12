// Module TopModule implements an XNOR gate using a multiplexer
// The XNOR operation outputs 1 when both inputs are the same (either both 0 or both 1), and outputs 0 otherwise
module TopModule(
    input a,  // Input signal a
    input b,  // Input signal b
    output out // Output signal out
);

// Use a multiplexer to compute the XNOR operation
wire sel = ~(a ^ b);  // Select line: 1 when a and b are the same, 0 otherwise
assign out = (sel)? 1'b1 : 1'b0;  // MUX: output 1 when sel is 1, output 0 when sel is 0

endmodule