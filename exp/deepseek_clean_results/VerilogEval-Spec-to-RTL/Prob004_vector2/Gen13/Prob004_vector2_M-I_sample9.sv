module TopModule (
    input  [31:0] in,
    output [31:0] out
);
    // Named byte positions for better readability
    localparam BYTE3 = 31:24,
               BYTE2 = 23:16,
               BYTE1 = 15:8,
               BYTE0 = 7:0;

    // Byte order reversal with named parameters
    assign out = {in[BYTE0], in[BYTE1], in[BYTE2], in[BYTE3]};
endmodule