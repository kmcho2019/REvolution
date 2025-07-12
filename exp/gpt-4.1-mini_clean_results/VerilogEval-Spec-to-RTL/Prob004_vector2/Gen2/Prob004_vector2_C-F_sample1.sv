module TopModule (
    input  [31:0] in,
    output [31:0] out
);

localparam BYTE_WIDTH = 8;
localparam BYTE_COUNT = 4;

genvar i;
generate
    for (i = 0; i < BYTE_COUNT; i = i + 1) begin : byte_reverse
        assign out[(i*BYTE_WIDTH) +: BYTE_WIDTH] = in[((BYTE_COUNT - 1 - i)*BYTE_WIDTH) +: BYTE_WIDTH];
    end
endgenerate

endmodule