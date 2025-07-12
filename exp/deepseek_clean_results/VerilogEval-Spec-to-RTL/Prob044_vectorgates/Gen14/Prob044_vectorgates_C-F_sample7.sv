module TopModule #(parameter WIDTH = 3) (
    input [WIDTH-1:0] a,
    input [WIDTH-1:0] b,
    output [WIDTH-1:0] out_or_bitwise,
    output out_or_logical,
    output [2*WIDTH-1:0] out_not
);
    // Bitwise OR operation (direct implementation for best performance)
    assign out_or_bitwise = a | b;
    
    // Logical OR using reduction operator (most power efficient)
    // True if any bit in a OR any bit in b is high
    assign out_or_logical = (|a) || (|b);
    
    // NOT operations with b in upper bits, a in lower bits
    // out_not[5:3] = ~b, out_not[2:0] = ~a (for WIDTH=3)
    assign out_not = {~b, ~a};
endmodule