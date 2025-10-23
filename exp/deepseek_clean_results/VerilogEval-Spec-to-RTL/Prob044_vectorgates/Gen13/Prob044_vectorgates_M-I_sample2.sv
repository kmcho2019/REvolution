module TopModule (
    input [2:0] a,
    input [2:0] b,
    output [2:0] out_or_bitwise,
    output out_or_logical,
    output [5:0] out_not
);
    // Direct bitwise OR implementation (may map better to target technology)
    assign out_or_bitwise = a | b;
    
    // Simplified logical OR (reduction OR of bitwise OR)
    assign out_or_logical = |(a | b);
    
    // Concatenated NOT operations with b in upper bits, a in lower
    assign out_not = {~b, ~a};
endmodule