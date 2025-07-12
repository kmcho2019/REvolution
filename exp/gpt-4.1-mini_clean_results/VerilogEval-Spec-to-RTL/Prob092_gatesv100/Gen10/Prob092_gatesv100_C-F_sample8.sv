module TopModule(
    input  wire [99:0] in,
    output wire [99:0] out_both,
    output wire [99:0] out_any,
    output wire [99:0] out_different
);

    genvar i;

    // out_both[i] = in[i] & in[i+1] for i=0..98; out_both[99] = 0
    assign out_both[98:0] = in[98:0] & in[99:1];
    assign out_both[99] = 1'b0; // no left neighbor for in[99]

    // out_any[i] = in[i] | in[i-1] for i=1..99; out_any[0] = 0
    assign out_any[99:1] = in[99:1] | in[98:0];
    assign out_any[0] = 1'b0; // no right neighbor for in[0]

    // out_different[i] = in[i] ^ in[left_neighbor]
    // left neighbor wraps around:
    //   for i=0..98, left neighbor = i+1
    //   for i=99, left neighbor = 0
    generate
        for (i = 0; i < 99; i = i + 1) begin : gen_out_different_no_wrap
            assign out_different[i] = in[i] ^ in[i+1];
        end
    endgenerate
    // Handle wrap-around neighbor for last bit
    assign out_different[99] = in[99] ^ in[0];

endmodule