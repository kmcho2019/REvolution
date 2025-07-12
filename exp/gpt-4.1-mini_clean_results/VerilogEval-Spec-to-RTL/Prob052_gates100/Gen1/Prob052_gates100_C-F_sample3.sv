module TopModule (
    input  [99:0] in,
    output        out_and,
    output        out_or,
    output        out_xor
);
    // Reduction AND: outputs 1 only if all bits in 'in' are 1
    assign out_and = &in;  
    
    // Reduction OR: outputs 1 if any bit in 'in' is 1
    assign out_or  = |in;  
    
    // Reduction XOR: outputs 1 if an odd number of bits in 'in' are 1
    assign out_xor = ^in;  
endmodule