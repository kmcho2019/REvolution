module TopModule (
    input [2:0] a,
    input [2:0] b,
    output [2:0] out_or_bitwise,
    output out_or_logical,
    output [5:0] out_not
);
    // Single-pass computation of all required operations
    assign out_or_bitwise = a | b;                     // Bitwise OR
    assign out_or_logical = |(a | b);                  // Logical OR derived from bitwise result
    assign out_not = {~b, ~a};                        // Concatenated NOT operations
    
    // Alternative implementation showing operation sharing:
    // wire [2:0] bit_or = a | b;
    // assign out_or_bitwise = bit_or;
    // assign out_or_logical = |bit_or;
    // assign out_not = {~b, ~a};
endmodule