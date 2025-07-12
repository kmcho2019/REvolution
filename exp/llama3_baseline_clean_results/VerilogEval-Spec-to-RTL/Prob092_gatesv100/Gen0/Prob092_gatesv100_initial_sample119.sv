module TopModule(
    input  [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

    // Initialize output vectors
    assign out_both[99] = 0;
    assign out_any[0] = 0;

    // Generate out_both vector
    genvar i;
    generate
        for (i = 0; i < 99; i++) begin
            assign out_both[i] = in[i] & in[i+1];
        end
    endgenerate

    // Generate out_any vector
    generate
        for (i = 1; i < 100; i++) begin
            assign out_any[i] = in[i] | in[i-1];
        end
    endgenerate

    // Generate out_different vector
    generate
        for (i = 0; i < 100; i++) begin
            assign out_different[i] = in[i] ^ in[(i+1)%100];
        end
    endgenerate

endmodule