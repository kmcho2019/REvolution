module TopModule (
    input  [31:0] in,
    output [31:0] out
);
    // Explicit byte reversal using parameterized approach
    assign out = {in[0*8 +: 8],  // Byte 0
                  in[1*8 +: 8],  // Byte 1
                  in[2*8 +: 8],  // Byte 2
                  in[3*8 +: 8]}; // Byte 3
endmodule