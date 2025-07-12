// Module declaration for a 2-to-1 multiplexer
module TopModule(
    input  a,  // Input a
    input  b,  // Input b
    input  sel, // Select input
    output out  // Output
);

// Implement a 2-to-1 multiplexer using basic logical operations
assign out = (a & ~sel) | (b & sel);

endmodule