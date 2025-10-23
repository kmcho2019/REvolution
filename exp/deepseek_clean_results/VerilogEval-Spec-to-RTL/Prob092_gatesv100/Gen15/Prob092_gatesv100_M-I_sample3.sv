module TopModule (
    input [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

    // Shared left neighbor index computation
    genvar i;
    generate
        for (i = 0; i < 100; i = i + 1) begin: bit_ops
            // Compute left neighbor index (wrapped for MSB)
            wire left_idx = (i == 99) ? 0 : (i + 1);
            wire left_bit = in[left_idx];
            
            // Compute right neighbor index (for out_any)
            wire right_bit = (i == 0) ? 1'b0 : in[i-1];
            
            // Output assignments
            assign out_both[i] = (i == 99) ? 1'b0 : (in[i] & left_bit);
            assign out_any[i] = (i == 0) ? 1'b0 : (in[i] | right_bit);
            assign out_different[i] = in[i] ^ left_bit;
        end
    endgenerate

endmodule