module TopModule (
    input [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

    // Single-pass computation with circular indexing
    genvar i;
    generate
        for (i = 0; i < 100; i = i + 1) begin: bit_ops
            localparam left = (i == 99) ? 0 : (i + 1);
            localparam right = (i == 0) ? 99 : (i - 1);
            
            // out_both: current AND left (special case for MSB)
            assign out_both[i] = (i == 99) ? 1'b0 : (in[i] & in[left]);
            
            // out_any: current OR right (special case for LSB)
            assign out_any[i] = (i == 0) ? 1'b0 : (in[i] | in[right]);
            
            // out_different: current XOR left (with wrap-around)
            assign out_different[i] = in[i] ^ in[left];
        end
    endgenerate

endmodule