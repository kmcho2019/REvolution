module TopModule (
    input  [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

    genvar i;

    // out_both[i] = in[i] & in[i+1] for i=0..98; out_both[99] = 0
    generate
        for (i = 0; i < 99; i = i + 1) begin : gen_out_both
            assign out_both[i] = in[i] & in[i+1];
        end
    endgenerate
    assign out_both[99] = 1'b0;

    // out_any[i] = in[i] | in[i-1] for i=1..99; out_any[0] = 0
    generate
        for (i = 1; i < 100; i = i + 1) begin : gen_out_any
            assign out_any[i] = in[i] | in[i-1];
        end
    endgenerate
    assign out_any[0] = 1'b0;

    // out_different[i] = in[i] ^ in[(i+1) % 100]
    generate
        for (i = 0; i < 99; i = i + 1) begin : gen_out_different
            assign out_different[i] = in[i] ^ in[i+1];
        end
    endgenerate
    // wrap-around for last bit
    assign out_different[99] = in[99] ^ in[0];

endmodule