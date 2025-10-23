module TopModule #(parameter WIDTH = 3) (
    input [WIDTH-1:0] a,
    input [WIDTH-1:0] b,
    output [WIDTH-1:0] out_or_bitwise,
    output out_or_logical,
    output [2*WIDTH-1:0] out_not
);
    // Bitwise OR - parallel operation on all bits
    assign out_or_bitwise = a | b;
    
    // Logical OR - reduction of bitwise OR result
    assign out_or_logical = |(a | b);
    
    // Concatenated NOT operations:
    // Upper bits [5:3] = ~b
    // Lower bits [2:0] = ~a
    assign out_not = {~b, ~a};
endmodule