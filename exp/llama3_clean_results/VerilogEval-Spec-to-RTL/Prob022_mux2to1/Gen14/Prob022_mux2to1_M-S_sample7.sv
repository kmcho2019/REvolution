// Module declaration for a simplified 2-to-1 multiplexer
module TopModule(
    input  a,  // Input a
    input  b,  // Input b
    input  sel, // Select input
    output out  // Output
);
    
// Implement a 2-to-1 multiplexer using the ternary operator
assign out = sel ? b : a;

endmodule