module TopModule (
    input [2:0] a,
    input [2:0] b,
    output [2:0] out_or_bitwise,
    output out_or_logical,
    output [5:0] out_not
);
    // Bitwise OR operation - parallel bit operations
    assign out_or_bitwise = a | b;
    
    // Efficient logical OR using single reduction operation
    // Returns true if any bit in either input is high
    assign out_or_logical = |(a | b);
    
    // Concatenated NOT operations with:
    // - Inverse of b in upper bits [5:3]
    // - Inverse of a in lower bits [2:0]
    assign out_not = {~b, ~a};
endmodule