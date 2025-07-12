module TopModule #(parameter WIDTH = 3) (
    input [WIDTH-1:0] a,
    input [WIDTH-1:0] b,
    output [WIDTH-1:0] out_or_bitwise,
    output out_or_logical,
    output [2*WIDTH-1:0] out_not
);
    // Bitwise OR - direct implementation for best timing
    assign out_or_bitwise = a | b;
    
    // Logical OR - reduction of bitwise result for efficiency
    assign out_or_logical = |out_or_bitwise;
    
    // NOT operation - concatenated for compact implementation
    assign out_not = {~b, ~a};
endmodule