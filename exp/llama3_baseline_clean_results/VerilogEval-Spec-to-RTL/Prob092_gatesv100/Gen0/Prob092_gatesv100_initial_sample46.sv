module TopModule(
    input [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

    assign out_both[99] = 1'b0; // No left neighbor for the leftmost bit
    assign out_any[0] = 1'b0; // No right neighbor for the rightmost bit
    
    // Generate out_both
    genvar i;
    generate
        for (i = 0; i < 99; i = i + 1) begin
            assign out_both[i] = in[i] & in[i+1];
        end
    endgenerate

    // Generate out_any
    genvar j;
    generate
        for (j = 1; j < 100; j = j + 1) begin
            assign out_any[j] = in[j] | in[j-1];
        end
    endgenerate

    // Generate out_different
    genvar k;
    generate
        for (k = 1; k < 100; k = k + 1) begin
            assign out_different[k] = in[k] ^ in[k-1];
        end
        // Handle the wrap-around case for the leftmost bit
        assign out_different[0] = in[0] ^ in[99];
    endgenerate

endmodule