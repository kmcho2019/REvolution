module TopModule(
    input [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

    // Initialize the out_both vector
    assign out_both[99] = 1'b0; // out_both[99] is always 0
    genvar i;
    generate
        for (i = 0; i < 99; i = i + 1) begin
            assign out_both[i] = in[i] & in[i+1];
        end
    endgenerate

    // Initialize the out_any vector
    assign out_any[0] = 1'b0; // out_any[0] is always 0
    generate
        for (i = 1; i < 100; i = i + 1) begin
            assign out_any[i] = in[i] | in[i-1];
        end
    endgenerate

    // Initialize the out_different vector with a single generate loop
    generate
        for (i = 0; i < 100; i = i + 1) begin
            if (i == 99) begin
                assign out_different[i] = in[i] ^ in[0];
            end else begin
                assign out_different[i] = in[i] ^ in[i+1];
            end
        end
    endgenerate

endmodule