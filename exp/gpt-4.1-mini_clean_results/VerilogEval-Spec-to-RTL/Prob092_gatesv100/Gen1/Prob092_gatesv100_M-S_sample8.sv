module TopModule(
    input  [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

    genvar i;

    // out_both[i] = in[i] & in[i+1], for i=0 to 98; out_both[99] = 0
    generate
        for (i = 0; i < 99; i = i + 1) begin
            assign out_both[i] = in[i] & in[i+1];
        end
        assign out_both[99] = 1'b0;
    endgenerate

    // out_any[i] = in[i] | in[i-1], for i=1 to 99; out_any[0] = 0
    generate
        assign out_any[0] = 1'b0;
        for (i = 1; i < 100; i = i + 1) begin
            assign out_any[i] = in[i] | in[i-1];
        end
    endgenerate

    // out_different[i] = in[i] ^ in[(i+1) mod 100]
    generate
        for (i = 0; i < 100; i = i + 1) begin
            assign out_different[i] = in[i] ^ in[(i+1) % 100];
        end
    endgenerate

endmodule