module TopModule (
    input  [3:0] in,
    output [3:0] out_both,
    output [3:0] out_any,
    output [3:0] out_different
);

    genvar i;

    // out_both: for i=0..2, out_both[i] = in[i] & in[i+1]; out_both[3] = 0 (no neighbor to left)
    generate
        for (i = 0; i < 3; i = i + 1) begin : gen_out_both
            assign out_both[i] = in[i] & in[i+1];
        end
    endgenerate
    assign out_both[3] = 1'b0;

    // out_any: for i=1..3, out_any[i] = in[i] | in[i-1]; out_any[0] = 0 (no neighbor to right)
    generate
        for (i = 1; i < 4; i = i + 1) begin : gen_out_any
            assign out_any[i] = in[i] | in[i-1];
        end
    endgenerate
    assign out_any[0] = 1'b0;

    // out_different: for i=0..3, out_different[i] = in[i] ^ in[(i+1) % 4], wrap-around neighbor to left
    generate
        for (i = 0; i < 4; i = i + 1) begin : gen_out_different
            assign out_different[i] = in[i] ^ in[(i+1) % 4];
        end
    endgenerate

endmodule