module TopModule (
    input [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

    // out_both generation
    assign out_both[99] = 1'b0;
    genvar i;
    generate
        for (i = 98; i >= 0; i = i - 1) begin : both_gen
            assign out_both[i] = in[i] & in[i+1];
        end
    endgenerate

    // out_any generation
    assign out_any[0] = 1'b0;
    genvar j;
    generate
        for (j = 1; j < 100; j = j + 1) begin : any_gen
            assign out_any[j] = in[j] | in[j-1];
        end
    endgenerate

    // out_different generation
    genvar k;
    generate
        for (k = 0; k < 100; k = k + 1) begin : diff_gen
            assign out_different[k] = in[k] ^ in[(k+1)%100];
        end
    endgenerate

endmodule