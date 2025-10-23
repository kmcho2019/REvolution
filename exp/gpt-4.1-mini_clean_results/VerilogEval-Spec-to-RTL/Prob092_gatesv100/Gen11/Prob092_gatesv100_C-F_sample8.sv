module TopModule(
    input  wire [99:0] in,
    output wire [99:0] out_both,
    output wire [99:0] out_any,
    output wire [99:0] out_different
);

    genvar i;
    generate
        for (i = 0; i < 100; i = i + 1) begin : bit_logic
            // out_both[i]: both in[i] and left neighbor in[i+1] are '1', except MSB out_both[99] = 0
            if (i < 99) begin
                assign out_both[i] = in[i] & in[i+1];
            end else begin
                assign out_both[i] = 1'b0;
            end

            // out_any[i]: any of in[i] or right neighbor in[i-1] is '1', except LSB out_any[0] = 0
            if (i > 0) begin
                assign out_any[i] = in[i] | in[i-1];
            end else begin
                assign out_any[i] = 1'b0;
            end

            // out_different[i]: in[i] different from left neighbor with wrap-around (neighbor of 99 is 0)
            if (i < 99) begin
                assign out_different[i] = in[i] ^ in[i+1];
            end else begin
                assign out_different[i] = in[99] ^ in[0];
            end
        end
    endgenerate

endmodule