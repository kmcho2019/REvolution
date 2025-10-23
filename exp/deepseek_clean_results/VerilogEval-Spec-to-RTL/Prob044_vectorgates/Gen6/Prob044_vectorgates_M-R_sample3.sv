module TopModule (
    input [2:0] a,
    input [2:0] b,
    output [2:0] out_or_bitwise,
    output out_or_logical,
    output [5:0] out_not
);
    
    // Bitwise OR operation
    assign out_or_bitwise = a | b;
    
    // Logical OR operation (OR of all bits in either input)
    assign out_or_logical = |(a | b);
    
    // Vector NOT operations with concatenation
    // b's inverse in upper bits [5:3], a's inverse in lower bits [2:0]
    assign out_not = {~b, ~a};

endmodule