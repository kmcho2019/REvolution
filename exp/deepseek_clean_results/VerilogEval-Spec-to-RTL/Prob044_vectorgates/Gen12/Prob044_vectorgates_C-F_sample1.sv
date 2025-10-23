module TopModule #(parameter WIDTH = 3) (
    input [WIDTH-1:0] a,
    input [WIDTH-1:0] b,
    output [WIDTH-1:0] out_or_bitwise,
    output out_or_logical,
    output [2*WIDTH-1:0] out_not
);
    // Bitwise OR operation - direct implementation for best timing
    assign out_or_bitwise = a | b;
    
    // Logical OR - single reduction operation for power efficiency
    assign out_or_logical = |(a | b);
    
    // Concatenated NOT operations:
    // - Upper bits: inverse of b [WIDTH*2-1:WIDTH]
    // - Lower bits: inverse of a [WIDTH-1:0]
    assign out_not = {~b, ~a};
endmodule