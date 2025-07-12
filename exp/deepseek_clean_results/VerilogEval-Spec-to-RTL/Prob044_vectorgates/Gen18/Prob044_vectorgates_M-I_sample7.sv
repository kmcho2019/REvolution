module TopModule #(parameter WIDTH = 3) (
    input [WIDTH-1:0] a,
    input [WIDTH-1:0] b,
    output [WIDTH-1:0] out_or_bitwise,
    output out_or_logical,
    output [2*WIDTH-1:0] out_not
);
    localparam TOTAL_BITS = 2*WIDTH;
    
    // Bitwise OR
    assign out_or_bitwise = a | b;
    
    // Logical OR (reduction OR of bitwise OR)
    assign out_or_logical = |(a | b);
    
    // NOT operations concatenated
    assign out_not = {~b, ~a};
endmodule