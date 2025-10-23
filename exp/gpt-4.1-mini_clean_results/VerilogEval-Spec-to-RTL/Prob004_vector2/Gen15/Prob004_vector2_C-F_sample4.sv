module TopModule (
    input  [31:0] in,
    output [31:0] out
);

    localparam BYTE_NUM = 4;
    localparam BYTE_WIDTH = 8;

    wire [31:0] reversed_bytes;

    genvar i;
    generate
        for (i = 0; i < BYTE_NUM; i = i + 1) begin : byte_reverse
            assign reversed_bytes[i*BYTE_WIDTH +: BYTE_WIDTH] = in[(BYTE_NUM - 1 - i)*BYTE_WIDTH +: BYTE_WIDTH];
        end
    endgenerate

    assign out = reversed_bytes;

endmodule