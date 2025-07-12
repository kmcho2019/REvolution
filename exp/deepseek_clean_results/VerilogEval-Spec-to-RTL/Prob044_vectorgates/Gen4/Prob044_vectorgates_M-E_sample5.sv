module TopModule (
    input [2:0] a,
    input [2:0] b,
    output [2:0] out_or_bitwise,
    output out_or_logical,
    output [5:0] out_not
);
    // Bitwise OR - direct parallel operation
    assign out_or_bitwise = a | b;
    
    // Logical OR - first OR vectors then reduce
    assign out_or_logical = |(a | b);
    
    // Vector NOT - concatenate inverted vectors with b in upper bits
    assign out_not = {~b, ~a};
endmodule