// Improved version with added documentation for clarity
module TopModule(
    input  a,  // Input a
    input  b,  // Input b
    input  sel, // Select input
    output out  // Output based on select
);

// Continuous assignment for 2-to-1 multiplexer logic
assign out = sel? b : a;

endmodule