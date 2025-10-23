module TopModule (
    input  [99:0] in,
    output [99:0] out
);

// Parameterized bit reversal for 100-bit vector
genvar i;
generate
    for (i = 0; i < 100; i = i + 1) begin : bit_reversal
        assign out[i] = in[99 - i];  // Mirror each bit position
    end
endgenerate

endmodule