module TopModule (
    input [2:0] a,
    input [2:0] b,
    output [2:0] out_or_bitwise,
    output out_or_logical,
    output [5:0] out_not
);
    // Parallel bitwise OR computation
    assign out_or_bitwise = a | b;
    
    // Optimized logical OR - wired OR of all bits
    assign out_or_logical = (|a) || (|b);
    
    // Shared inversion logic with concatenation
    assign out_not = {~b, ~a};
endmodule