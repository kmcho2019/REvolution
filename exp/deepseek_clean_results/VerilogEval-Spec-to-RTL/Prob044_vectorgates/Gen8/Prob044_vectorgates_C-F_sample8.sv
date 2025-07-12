module TopModule (
    input [2:0] a,
    input [2:0] b,
    output [2:0] out_or_bitwise,
    output out_or_logical,
    output [5:0] out_not
);
    // Bitwise OR operation - parallel computation
    assign out_or_bitwise = a | b;
    
    // Logical OR - efficient reduction operation
    assign out_or_logical = |(a | b);
    
    // Concatenated NOT operations:
    // Upper 3 bits [5:3] = ~b
    // Lower 3 bits [2:0] = ~a
    assign out_not = {~b, ~a};
endmodule