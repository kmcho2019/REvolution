// TopModule: Directly connects inputs to outputs as per the problem description.
module TopModule(
    input  a,  // Input signal a
    input  b,  // Input signal b
    input  c,  // Input signal c
    output w,  // Output signal w
    output x,  // Output signal x
    output y,  // Output signal y
    output z   // Output signal z
);

// Direct assignments to connect inputs to outputs
assign w = a;  // Connect a to w
assign x = b;  // Connect b to x
assign y = b;  // Connect b to y
assign z = c;  // Connect c to z

endmodule