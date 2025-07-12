module TopModule (
    input [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

    // out_both calculation
    assign out_both[99] = 1'b0;  // MSB has no left neighbor
    genvar i;
    generate
        for (i = 98; i >= 0; i = i - 1) begin : both_loop
            assign out_both[i] = in[i] & in[i+1];
        end
    endgenerate

    // out_any calculation
    assign out_any[0] = 1'b0;  // LSB has no right neighbor
    genvar j;
    generate
        for (j = 1; j < 100; j = j + 1) begin : any_loop
            assign out_any[j] = in[j] | in[j-1];
        end
    endgenerate

    // out_different calculation (with wrap-around)
    genvar k;
    generate
        for (k = 0; k < 100; k = k + 1) begin : diff_loop
            assign out_different[k] = in[k] ^ in[(k == 99) ? 0 : k+1];
        end
    endgenerate

endmodule