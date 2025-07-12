module TopModule #(parameter WIDTH = 3) (
    input [WIDTH-1:0] a,
    input [WIDTH-1:0] b,
    output [WIDTH-1:0] out_or_bitwise,
    output out_or_logical,
    output [2*WIDTH-1:0] out_not
);
    // Bitwise OR: Each bit of output is OR of corresponding input bits
    assign out_or_bitwise = a | b;
    
    // Logical OR: True if any bit in either input is 1
    // More efficient implementation using single reduction OR
    assign out_or_logical = |(a | b);
    
    // NOT operation: 
    // Upper half is inverse of b, lower half is inverse of a
    assign out_not = {~b, ~a};
endmodule