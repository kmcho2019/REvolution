module TopModule (
    input [2:0] a,
    input [2:0] b,
    output [2:0] out_or_bitwise,
    output out_or_logical,
    output [5:0] out_not
);
    // Direct implementation without submodules
    assign out_or_bitwise = a | b;            // Bitwise OR
    assign out_or_logical = |(a | b);         // More efficient logical OR
    assign out_not = {~b, ~a};                // Combined NOT operations
endmodule