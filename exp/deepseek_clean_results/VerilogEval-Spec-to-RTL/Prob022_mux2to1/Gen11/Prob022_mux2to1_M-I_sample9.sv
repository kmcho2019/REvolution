// Optimal 2:1 Multiplexer Implementation
module TopModule (
    input  a,    // Input A
    input  b,    // Input B
    input  sel,  // Select (0=A, 1=B)
    output out   // Output
);
    // Clear multiplexer implementation
    assign out = sel ? b : a;
endmodule