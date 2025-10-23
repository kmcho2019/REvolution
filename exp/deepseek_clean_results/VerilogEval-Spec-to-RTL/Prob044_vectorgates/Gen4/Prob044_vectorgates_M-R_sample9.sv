module TopModule (
    input [2:0] a,
    input [2:0] b,
    output [2:0] out_or_bitwise,
    output out_or_logical,
    output [5:0] out_not
);
    // Bitwise OR of inputs
    assign out_or_bitwise = a | b;
    
    // Logical OR (true if any bit in a OR any bit in b is set)
    assign out_or_logical = |(a | b);
    
    // Concatenated NOT operations with b in upper bits
    assign out_not = {~b, ~a};
endmodule