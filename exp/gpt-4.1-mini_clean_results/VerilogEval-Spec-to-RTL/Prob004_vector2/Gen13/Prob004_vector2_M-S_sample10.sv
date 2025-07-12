module TopModule (
    input  [31:0] in,
    output [31:0] out
);
    genvar i;
    generate
        for (i = 0; i < 4; i = i + 1) begin : byte_reverse
            assign out[(i*8)+7 -: 8] = in[((3 - i)*8)+7 -: 8];
        end
    endgenerate
endmodule