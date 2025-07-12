module TopModule (
    input  [31:0] in,
    output [31:0] out
);

    localparam BYTE_NUM = 4;

    genvar i;
    generate
        for (i = 0; i < BYTE_NUM; i = i + 1) begin : byte_reverse
            assign out[i*8 +: 8] = in[(BYTE_NUM - 1 - i)*8 +: 8];
        end
    endgenerate

endmodule