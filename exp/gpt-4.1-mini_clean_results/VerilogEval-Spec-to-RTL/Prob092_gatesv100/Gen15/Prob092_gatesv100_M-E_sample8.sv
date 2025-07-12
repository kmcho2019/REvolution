module TopModule(
    input  wire [99:0] in,
    output wire [99:0] out_both,
    output wire [99:0] out_any,
    output wire [99:0] out_different
);

    genvar i;

    // out_both[i] = in[i] & in[i+1], except out_both[99] = 0
    generate
        for (i = 0; i < 99; i = i + 1) begin : gen_out_both
            assign out_both[i] = in[i] & in[i+1];
        end
        assign out_both[99] = 1'b0; // No left neighbor
    endgenerate

    // out_any[i] = in[i] | in[i-1], except out_any[0] = 0
    generate
        assign out_any[0] = 1'b0; // No right neighbor
        for (i = 1; i < 100; i = i + 1) begin : gen_out_any
            assign out_any[i] = in[i] | in[i-1];
        end
    endgenerate

    // out_different[i] = in[i] ^ in[i-1], with wrap-around (in[0] ^ in[99])
    generate
        assign out_different[0] = in[0] ^ in[99];
        for (i = 1; i < 100; i = i + 1) begin : gen_out_different
            assign out_different[i] = in[i] ^ in[i-1];
        end
    endgenerate

endmodule