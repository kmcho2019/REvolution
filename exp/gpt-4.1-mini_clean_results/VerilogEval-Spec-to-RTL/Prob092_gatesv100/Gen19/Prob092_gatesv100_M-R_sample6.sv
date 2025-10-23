module TopModule(
    input  wire [99:0] in,
    output wire [99:0] out_both,
    output wire [99:0] out_any,
    output wire [99:0] out_different
);

    genvar i;

    // out_both: For bits 0 to 98, check if in[i] and in[i+1] are both 1; out_both[99] = 0
    generate
        for (i = 0; i < 99; i = i + 1) begin : gen_out_both
            assign out_both[i] = in[i] & in[i+1];
        end
    endgenerate
    assign out_both[99] = 1'b0;

    // out_any: For bits 1 to 99, check if in[i] or in[i-1] is 1; out_any[0] = 0
    generate
        for (i = 1; i < 100; i = i + 1) begin : gen_out_any
            assign out_any[i] = in[i] | in[i-1];
        end
    endgenerate
    assign out_any[0] = 1'b0;

    // out_different: For each bit i, compare in[i] with neighbor to left (i+1 mod 100)
    // Wrap-around at i=99 (neighbor is in[0])
    generate
        for (i = 0; i < 100; i = i + 1) begin : gen_out_different
            // neighbor index with wrap-around
            wire neighbor;
            assign neighbor = (i == 99) ? in[0] : in[i+1];
            assign out_different[i] = in[i] ^ neighbor;
        end
    endgenerate

endmodule