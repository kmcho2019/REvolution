module TopModule(
    input [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

    // Initialize all output bits to 0 by default
    assign out_both[99] = 0;
    assign out_any[0] = 0;

    // Generate out_both output vector
    genvar i;
    generate
        for (i = 0; i < 99; i = i + 1) begin
            assign out_both[i] = in[i] & in[i + 1];
        end
    endgenerate

    // Generate out_any output vector
    generate
        for (i = 1; i < 100; i = i + 1) begin
            assign out_any[i] = in[i] | in[i - 1];
        end
    endgenerate

    // Generate out_different output vector with wrap-around
    generate
        for (i = 0; i < 100; i = i + 1) begin
            if (i == 0) begin
                assign out_different[i] = in[i] ^ in[99];
            end else begin
                assign out_different[i] = in[i] ^ in[i - 1];
            end
        end
    endgenerate

endmodule