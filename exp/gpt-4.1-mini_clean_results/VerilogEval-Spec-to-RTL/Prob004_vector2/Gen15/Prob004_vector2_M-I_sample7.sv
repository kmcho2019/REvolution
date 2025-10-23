module TopModule (
    input  [31:0] in,
    output [31:0] out
);
    localparam BYTE_WIDTH = 8;
    localparam NUM_BYTES = 32 / BYTE_WIDTH;

    genvar i;
    generate
        for (i = 0; i < NUM_BYTES; i = i + 1) begin : byte_reverse
            assign out[(i+1)*BYTE_WIDTH-1 : i*BYTE_WIDTH] = in[(NUM_BYTES-1 - i + 1)*BYTE_WIDTH-1 : (NUM_BYTES-1 - i)*BYTE_WIDTH];
        end
    endgenerate

endmodule