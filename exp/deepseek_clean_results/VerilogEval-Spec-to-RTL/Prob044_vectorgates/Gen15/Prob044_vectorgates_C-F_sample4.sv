module TopModule #(parameter WIDTH = 3) (
    input [WIDTH-1:0] a,
    input [WIDTH-1:0] b,
    output [WIDTH-1:0] out_or_bitwise,
    output out_or_logical,
    output [2*WIDTH-1:0] out_not
);
    // Bitwise OR: Parallel OR operation on each bit pair
    assign out_or_bitwise = a | b;
    
    // Logical OR: Single reduction OR of all bits (most efficient implementation)
    assign out_or_logical = |(a | b);
    
    // Vector NOT: Concatenated NOT operations with b in upper bits, a in lower bits
    assign out_not = {~b, ~a};
endmodule