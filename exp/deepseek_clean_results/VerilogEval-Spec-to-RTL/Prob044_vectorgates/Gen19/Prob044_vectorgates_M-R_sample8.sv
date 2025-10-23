module TopModule #(parameter WIDTH = 3) (
    input [WIDTH-1:0] a,
    input [WIDTH-1:0] b,
    output [WIDTH-1:0] out_or_bitwise,
    output out_or_logical,
    output [2*WIDTH-1:0] out_not
);
    // Bitwise OR (direct assignment)
    assign out_or_bitwise = a | b;
    
    // Logical OR (reduction OR of bitwise OR)
    assign out_or_logical = |(a | b);
    
    // NOT operations with concatenation
    assign out_not = {~b, ~a};
endmodule