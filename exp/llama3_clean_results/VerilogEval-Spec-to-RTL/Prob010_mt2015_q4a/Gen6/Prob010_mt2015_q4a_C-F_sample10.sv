module TopModule(
    input  logic x,  // Input signal x
    input  logic y,  // Input signal y
    output logic z   // Output signal z
);

// Directly implement the simplified boolean function z = x & ~y
assign z = x & ~y;

endmodule