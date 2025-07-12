module TopModule #(parameter WIDTH = 3) (
    input [WIDTH-1:0] a,
    input [WIDTH-1:0] b,
    output [WIDTH-1:0] out_or_bitwise,
    output out_or_logical,
    output [2*WIDTH-1:0] out_not
);
    // Bitwise OR operation (parallel computation)
    assign out_or_bitwise = a | b;
    
    // Efficient logical OR using reduction operator
    // Returns true if any bit in either vector is high
    assign out_or_logical = |(a | b);
    
    // Concatenated NOT operations:
    // - Upper bits: inverse of b (bits [5:3] when WIDTH=3)
    // - Lower bits: inverse of a (bits [2:0] when WIDTH=3)
    assign out_not = {~b, ~a};
endmodule