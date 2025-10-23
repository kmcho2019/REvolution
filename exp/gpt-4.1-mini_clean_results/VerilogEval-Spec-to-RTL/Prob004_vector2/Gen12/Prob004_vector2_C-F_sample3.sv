module TopModule (
    input  [31:0] in,
    output [31:0] out
);

genvar i;
generate
    // Assign each byte of 'out' by reversing the byte order of 'in'
    // 'out' byte i receives byte (3 - i) of 'in' using indexed part-select
    for (i = 0; i < 4; i = i + 1) begin : byte_reverse
        assign out[i*8 +: 8] = in[(3 - i)*8 +: 8];
    end
endgenerate

endmodule