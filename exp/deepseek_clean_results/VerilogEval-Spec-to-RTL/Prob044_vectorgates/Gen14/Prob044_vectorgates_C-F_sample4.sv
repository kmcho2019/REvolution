module TopModule #(parameter WIDTH = 3) (
    input [WIDTH-1:0] a,
    input [WIDTH-1:0] b,
    output [WIDTH-1:0] out_or_bitwise,
    output out_or_logical,
    output [2*WIDTH-1:0] out_not
);
    // Bitwise OR - direct assignment for best timing
    assign out_or_bitwise = a | b;
    
    // Logical OR - reduction for lowest power
    assign out_or_logical = |(a | b);
    
    // NOT operations with b in upper bits [5:3], a in lower [2:0]
    assign out_not = {~b, ~a};
endmodule