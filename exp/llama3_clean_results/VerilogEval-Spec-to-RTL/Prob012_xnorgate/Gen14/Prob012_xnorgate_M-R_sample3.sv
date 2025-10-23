// Module TopModule implements an XNOR gate using basic logical operations
// The XNOR operation outputs 1 when both inputs are the same (either both 0 or both 1), and outputs 0 otherwise
module TopModule(
    input a,  // Input signal a
    input b,  // Input signal b
    output out // Output signal out
);

// Define the XNOR operation using basic logical gates
// (a XNOR b) = (a AND b) OR (NOT a AND NOT b)
assign out = (a & b) | (~a & ~b);

endmodule