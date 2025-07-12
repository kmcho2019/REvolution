module TopModule (
    input  [99:0] in,
    output [99:0] out
);

// First reverse the order of 10-bit chunks
wire [99:0] chunk_reversed;
generate
    genvar i;
    for (i = 0; i < 10; i = i + 1) begin : CHUNK_REV
        assign chunk_reversed[i*10 +: 10] = in[(9-i)*10 +: 10];
    end
endgenerate

// Then reverse bits within each 10-bit chunk
generate
    genvar j, k;
    for (j = 0; j < 10; j = j + 1) begin : BIT_REV
        for (k = 0; k < 10; k = k + 1) begin : BIT_ASSIGN
            assign out[j*10 + k] = chunk_reversed[j*10 + (9 - k)];
        end
    end
endgenerate

endmodule