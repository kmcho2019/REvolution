module TopModule(
    input  [31:0] in,
    output [31:0] out
);

    // Assign each byte of the input vector to the output vector in reverse order
    assign out[7:0]   = in[31:24]; // Byte 4 to Byte 1
    assign out[15:8]  = in[23:16]; // Byte 3 to Byte 2
    assign out[23:16] = in[15:8];  // Byte 2 to Byte 3
    assign out[31:24] = in[7:0];   // Byte 1 to Byte 4

endmodule