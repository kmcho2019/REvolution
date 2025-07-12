module TopModule (
    input [2:0] a,
    input [2:0] b,
    output [2:0] out_or_bitwise,
    output out_or_logical,
    output [5:0] out_not
);
    // Bitwise OR - direct implementation for best performance
    assign out_or_bitwise = a | b;
    
    // Logical OR - optimized reduction OR implementation
    // More power efficient than separate OR trees
    assign out_or_logical = |a || |b;
    
    // Vector NOT - shared computation with b in upper bits [5:3], a in lower bits [2:0]
    // Single NOT operations for each input vector
    assign out_not = {~b, ~a};
endmodule