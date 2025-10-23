module TopModule(
    input [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

    genvar i;
    // Generate block for out_both
    generate
        for (i = 0; i < 100; i = i + 1) begin
            assign out_both[i] = (i == 99)? 1'b0 : (in[i] & in[i+1]);
        end
    endgenerate

    // Generate block for out_any
    generate
        for (i = 0; i < 100; i = i + 1) begin
            assign out_any[i] = (i == 0)? 1'b0 : (in[i] | in[i-1]);
        end
    endgenerate

    // Generate block for out_different, handling wrap-around
    generate
        for (i = 0; i < 100; i = i + 1) begin
            assign out_different[i] = in[i] ^ in[(i+1) % 100];
        end
    endgenerate

endmodule