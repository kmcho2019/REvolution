module TopModule #(parameter WIDTH = 3) (
    input [WIDTH-1:0] a,
    input [WIDTH-1:0] b,
    output [WIDTH-1:0] out_or_bitwise,
    output out_or_logical,
    output [2*WIDTH-1:0] out_not
);
    // Bitwise OR operation (parallel bit operations)
    assign out_or_bitwise = a | b;
    
    // Efficient logical OR using single reduction operation
    // More power efficient than separate reductions with OR
    assign out_or_logical = |(a | b);
    
    // Concatenated NOT operations:
    // - Upper bits: inverse of b (for better bit ordering visibility)
    // - Lower bits: inverse of a
    assign out_not = {~b, ~a};
endmodule