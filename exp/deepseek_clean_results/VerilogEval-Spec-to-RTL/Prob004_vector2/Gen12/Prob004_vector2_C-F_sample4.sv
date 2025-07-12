module TopModule (
    input  [31:0] in,
    output [31:0] out
);
    // Optimal byte reversal with explicit indexing
    // Direct concatenation for zero logic depth
    assign out = {in[7:0],   // Byte 3 becomes byte 0
                 in[15:8],   // Byte 2 becomes byte 1
                 in[23:16],  // Byte 1 becomes byte 2
                 in[31:24]}; // Byte 0 becomes byte 3
endmodule