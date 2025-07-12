module TopModule (
    input  [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

    assign out_both[99] = 1'b0;  // No neighbor to the left for in[99]
    assign out_any[0] = 1'b0;    // No neighbor to the right for in[0]

    // Generate out_both
    genvar i;
    generate
        for (i = 98; i >= 0; i = i - 1) begin
            assign out_both[i] = in[i] & in[i + 1];
        end
    endgenerate

    // Generate out_any
    generate
        for (i = 1; i <= 99; i = i + 1) begin
            assign out_any[i] = in[i] | in[i - 1];
        end
    endgenerate

    // Generate out_different
    generate
        for (i = 98; i >= 1; i = i - 1) begin
            assign out_different[i] = in[i] ^ in[i + 1];
        end
        assign out_different[0] = in[0] ^ in[99];  // Wrap around for in[0]
    endgenerate

endmodule