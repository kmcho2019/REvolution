module TopModule(
    input  wire [99:0] in,
    output wire [99:0] out_both,
    output wire [99:0] out_any,
    output wire [99:0] out_different
);
    genvar i;

    // out_both[i] = in[i] & in[i+1] for i=0..98; out_both[99] = 0 (no left neighbor)
    generate
        for (i = 0; i < 99; i = i + 1) begin : gen_out_both
            assign out_both[i] = in[i] & in[i+1];
        end
        assign out_both[99] = 1'b0;
    endgenerate

    // out_any[i] = in[i] | in[i-1] for i=1..99; out_any[0] = 0 (no right neighbor)
    generate
        assign out_any[0] = 1'b0;
        for (i = 1; i < 100; i = i + 1) begin : gen_out_any
            assign out_any[i] = in[i] | in[i-1];
        end
    endgenerate

    // out_different[i] = in[i] ^ in[(i-1) mod 100] with wrap-around neighbor
    generate
        for (i = 0; i < 100; i = i + 1) begin : gen_out_diff
            if (i == 0) begin
                assign out_different[i] = in[i] ^ in[99];
            end else begin
                assign out_different[i] = in[i] ^ in[i-1];
            end
        end
    endgenerate

endmodule