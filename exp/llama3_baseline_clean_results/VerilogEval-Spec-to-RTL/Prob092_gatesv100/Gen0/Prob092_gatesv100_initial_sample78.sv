module TopModule(
    input  [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

    // Initialize outputs
    assign out_both[99] = 0;
    assign out_any[0] = 0;

    // Generate out_both
    genvar i;
    generate
        for (i = 98; i >= 0; i--) begin
            assign out_both[i] = in[i] & in[i+1];
        end
    endgenerate

    // Generate out_any
    genvar j;
    generate
        for (j = 1; j <= 99; j++) begin
            assign out_any[j] = in[j] | in[j-1];
        end
    endgenerate

    // Generate out_different
    genvar k;
    generate
        for (k = 0; k <= 98; k++) begin
            assign out_different[k] = ~ (in[k] ^ in[k+1]);
        end
        assign out_different[99] = ~ (in[99] ^ in[0]);
    endgenerate

endmodule