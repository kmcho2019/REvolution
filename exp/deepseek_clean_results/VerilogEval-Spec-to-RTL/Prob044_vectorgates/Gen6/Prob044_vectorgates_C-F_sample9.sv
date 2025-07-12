module TopModule #(parameter WIDTH = 3) (
    input [WIDTH-1:0] a,
    input [WIDTH-1:0] b,
    output [WIDTH-1:0] out_or_bitwise,
    output out_or_logical,
    output [2*WIDTH-1:0] out_not
);
    // Bitwise OR operation (direct implementation for efficiency)
    assign out_or_bitwise = a | b;
    
    // Optimized logical OR using single reduction operation
    assign out_or_logical = |(a | b);
    
    // Concatenated NOT operations with b in upper bits
    assign out_not = {~b, ~a};
endmodule