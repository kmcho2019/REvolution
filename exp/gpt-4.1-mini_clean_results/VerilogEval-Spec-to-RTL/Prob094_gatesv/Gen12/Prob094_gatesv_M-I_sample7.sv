module TopModule (
    input  wire [3:0] in,
    output wire [3:0] out_both,
    output wire [3:0] out_any,
    output wire [3:0] out_different
);

    genvar i;

    // out_both[i] = in[i] & in[i+1] for i=0..2, out_both[3] = 0 (no neighbor)
    generate
        for (i = 0; i < 3; i = i + 1) begin : gen_out_both
            assign out_both[i] = in[i] & in[i+1];
        end
    endgenerate
    assign out_both[3] = 1'b0;

    // out_any[i] = in[i] | in[i-1] for i=1..3, out_any[0] = 0 (no neighbor)
    assign out_any[0] = 1'b0;
    generate
        for (i = 1; i < 4; i = i + 1) begin : gen_out_any
            assign out_any[i] = in[i] | in[i-1];
        end
    endgenerate

    // out_different[i] = in[i] ^ neighbor to left (i+1 wrapping)
    assign out_different[0] = in[0] ^ in[1];
    assign out_different[1] = in[1] ^ in[2];
    assign out_different[2] = in[2] ^ in[3];
    assign out_different[3] = in[3] ^ in[0];

endmodule