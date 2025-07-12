// TopModule: A simple 2-input AND gate module
module TopModule(
    // Input a: First input of the AND gate
    input  a,
    // Input b: Second input of the AND gate
    input  b,
    // Output out: Result of the AND operation between a and b
    output out
);

// Implementing a 2-input AND gate using a continuous assignment
// This is the most efficient way to describe simple combinational logic in Verilog
assign out = a & b;

endmodule