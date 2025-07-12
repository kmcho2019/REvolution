module TopModule (
    input [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

    // Single-pass optimized computation
    genvar i;
    generate
        for (i = 0; i < 100; i = i + 1) begin: bit_ops
            // Compute left neighbor index with wrap-around for out_different
            localparam left = (i == 99) ? 0 : (i + 1);
            
            // Shared left neighbor value
            wire left_val = in[left];
            
            // out_both: current AND left (0 for MSB)
            assign out_both[i] = (i == 99) ? 1'b0 : (in[i] & left_val);
            
            // out_any: current OR right (0 for LSB)
            assign out_any[i] = (i == 0) ? 1'b0 : (in[i] | in[i-1]);
            
            // out_different: current XOR left (with wrap-around)
            assign out_different[i] = in[i] ^ left_val;
        end
    endgenerate

endmodule