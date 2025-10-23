module TopModule (
    input        sel,
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] out // Change the output to be 8 bits wide
);

    assign out = (~sel & {8{1'b0}}) ? a : b; // Using ternary operator for better readability
    // Alternatively, you could also use the bitwise AND and OR operators as follows:
    // assign out = (~sel) ? a : b; // Since sel is single bit, no need for bitwise AND

endmodule