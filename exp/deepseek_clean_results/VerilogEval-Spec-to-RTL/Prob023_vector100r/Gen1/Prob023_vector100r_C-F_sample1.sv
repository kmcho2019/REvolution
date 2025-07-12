module TopModule (
    input  [99:0] in,
    output [99:0] out
);

    // Reverse the bit order of the 100-bit input
    genvar i;
    generate
        for (i = 0; i < 100; i = i + 1) begin : reverse_bits
            assign out[i] = in[99 - i];  // Mirror the bits
        end
    endgenerate

endmodule