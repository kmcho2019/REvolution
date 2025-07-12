module TopModule(
    input  wire [99:0] in,
    output wire [99:0] out_both,
    output wire [99:0] out_any,
    output wire [99:0] out_different
);

    genvar i;
    generate
        for (i = 0; i < 100; i = i + 1) begin : bit_logic
            // out_both[i]: both in[i] and in[i+1] are 1, except for i=99 (no left neighbor)
            if (i < 99) begin
                assign out_both[i] = in[i] & in[i + 1];
            end else begin
                assign out_both[i] = 1'b0;
            end

            // out_any[i]: any of in[i] or in[i-1] is 1, except i=0 (no right neighbor)
            if (i > 0) begin
                assign out_any[i] = in[i] | in[i - 1];
            end else begin
                assign out_any[i] = 1'b0;
            end

            // out_different[i]: in[i] differs from neighbor to left with wrap-around
            // neighbor to left of in[0] is in[99]
            if (i == 0) begin
                assign out_different[i] = in[i] ^ in[99];
            end else begin
                assign out_different[i] = in[i] ^ in[i - 1];
            end
        end
    endgenerate

endmodule