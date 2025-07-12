module TopModule (
    input [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

    // out_both: current bit AND left neighbor (except MSB which is 0)
    assign out_both[99] = 1'b0;
    assign out_both[98:0] = in[98:0] & in[99:1];

    // out_any: current bit OR right neighbor (except LSB which is 0)
    assign out_any[0] = 1'b0;
    assign out_any[99:1] = in[99:1] | in[98:0];

    // out_different: current bit XOR left neighbor (with wrap-around)
    genvar i;
    generate
        for (i = 0; i < 100; i = i + 1) begin : diff_gen
            assign out_different[i] = in[i] ^ in[(i == 99) ? 0 : i+1];
        end
    endgenerate

endmodule