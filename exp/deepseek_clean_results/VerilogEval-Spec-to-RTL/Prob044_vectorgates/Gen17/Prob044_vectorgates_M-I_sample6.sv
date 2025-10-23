module TopModule (
    input [2:0] a,
    input [2:0] b,
    output [2:0] out_or_bitwise,
    output out_or_logical,
    output [5:0] out_not
);
    
    // Bitwise OR operation
    assign out_or_bitwise = a | b;
    
    // Optimized Logical OR: equivalent to (|a) || (|b) but more efficient
    assign out_or_logical = |out_or_bitwise;
    
    // Vector NOT with proper bit ordering
    assign out_not = {~b, ~a};

endmodule