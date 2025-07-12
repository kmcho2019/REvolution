// Novel Module TopModule implements an XNOR gate using AND and OR gates
// The XNOR operation outputs 1 when both inputs are the same (either both 0 or both 1), and outputs 0 otherwise
module TopModule(
    input  logic a,  // Input signal a
    input  logic b,  // Input signal b
    output logic out // Output signal out
);

// Implement XNOR using AND and OR gates
// Condition 1: Both inputs are 1
logic both_high;
assign both_high = a & b;

// Condition 2: Both inputs are 0
logic both_low;
assign both_low = ~a & ~b;

// XNOR result is true if either condition is met
assign out = both_high | both_low;

endmodule