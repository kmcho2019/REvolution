module TopModule (
    input  [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

    genvar i;
    generate
        for (i = 0; i < 99; i = i + 1) begin : gen_loop
            // out_both[i] = in[i] & in[i+1]
            assign out_both[i] = in[i] & in[i+1];
            
            // out_any[i+1] = in[i+1] | in[i]
            assign out_any[i+1] = in[i+1] | in[i];
            
            // out_different[i] = in[i] ^ in[i+1]
            assign out_different[i] = in[i] ^ in[i+1];
        end
    endgenerate

    // Handle edge cases:
    // out_both[99] = 0 since in[99] has no left neighbor
    assign out_both[99] = 1'b0;

    // out_any[0] = 0 since in[0] has no right neighbor
    assign out_any[0] = 1'b0;

    // out_different[99] wraps around: in[99] ^ in[0]
    assign out_different[99] = in[99] ^ in[0];

endmodule