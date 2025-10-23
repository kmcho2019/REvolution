module TopModule (
    input  [99:0] in,
    output [99:0] out
);

// Reverse 5-bit chunks
wire [99:0] stage1;
genvar i;
generate
    for (i = 0; i < 20; i = i + 1) begin : chunk_reverse
        assign stage1[(i*5)+4 -:5] = in[((19-i)*5)+4 -:5];
    end
endgenerate

// Reverse bits within each 5-bit chunk
generate
    for (i = 0; i < 20; i = i + 1) begin : bit_reverse
        assign out[(i*5)+4 -:5] = {stage1[i*5], stage1[i*5+1], stage1[i*5+2], stage1[i*5+3], stage1[i*5+4]};
    end
endgenerate

endmodule