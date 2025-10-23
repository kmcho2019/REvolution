module TopModule (
    input  [99:0] in,
    output [99:0] out
);

// Reverse bits using a compact generate loop
genvar i;
generate
    for (i = 0; i < 100; i = i + 1) begin : bit_reversal
        assign out[i] = in[99 - i];  // Mirror each bit position
    end
endgenerate

endmodule