// TopModule: A simple combinational circuit implementing an AND gate
module TopModule(
    input  a,  // Input signal a
    input  b,  // Input signal b
    output q   // Output signal, result of a AND b
);

// Assign the output q as the logical AND of inputs a and b
assign q = a & b;

endmodule