module TopModule (
    input  [99:0] in,
    output [99:0] out
);

// First level: Reverse 10-bit segments
wire [99:0] segment_reversed;
genvar i;
generate
    for (i = 0; i < 10; i = i + 1) begin : reverse_segments
        assign segment_reversed[10*i +: 10] = in[10*(9-i) +: 10];
    end
endgenerate

// Second level: Reverse bits within each segment
genvar j;
generate
    for (j = 0; j < 10; j = j + 1) begin : reverse_bits_in_segment
        genvar k;
        for (k = 0; k < 10; k = k + 1) begin : reverse_bits
            assign out[10*j + k] = segment_reversed[10*j + (9-k)];
        end
    end
endgenerate

endmodule