module TopModule #(
    parameter VECTOR_LENGTH = 32,
    parameter BYTE_SIZE = 8
) (
    input  [VECTOR_LENGTH-1:0] in,
    output [VECTOR_LENGTH-1:0] out
);

    assign out[7:0]   = in[24:17]; // Byte 0
    assign out[15:8] = in[16:9];  // Byte 1
    assign out[23:16] = in[8:1];   // Byte 2
    assign out[31:24] = in[0:7];   // Byte 3

endmodule