module TopModule(
    input  wire [99:0] in,
    output wire [99:0] out_both,
    output wire [99:0] out_any,
    output wire [99:0] out_different
);

    genvar i;
    generate
        for (i = 0; i < 100; i = i + 1) begin : bit_assign
            // out_both[i]
            if (i == 99) begin
                assign out_both[i] = 1'b0; // no left neighbor
            end else begin
                assign out_both[i] = in[i] & in[i+1];
            end

            // out_any[i]
            if (i == 0) begin
                assign out_any[i] = 1'b0; // no right neighbor
            end else begin
                assign out_any[i] = in[i] | in[i-1];
            end

            // out_different[i]
            if (i == 0) begin
                assign out_different[i] = in[i] ^ in[99]; // wrap-around left neighbor
            end else begin
                assign out_different[i] = in[i] ^ in[i-1];
            end
        end
    endgenerate

endmodule