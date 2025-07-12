module TopModule (
    input [2:0] a,
    input [2:0] b,
    output [2:0] out_or_bitwise,
    output out_or_logical,
    output [5:0] out_not
);
    // Bitwise OR - direct parallel implementation
    assign out_or_bitwise = a | b;
    
    // Logical OR - optimized reduction implementation
    assign out_or_logical = |(a | b);
    
    // NOT operations with b in upper bits [5:3], a in [2:0]
    assign out_not = {~b, ~a};
endmodule