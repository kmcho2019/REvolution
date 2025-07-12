module TopModule(
    input  wire [99:0] in,
    output wire [99:0] out_both,
    output wire [99:0] out_any,
    output wire [99:0] out_different
);

    genvar i;
    generate
        for (i = 0; i < 100; i = i + 1) begin : compute_bits
            // out_both[i]: Check if in[i] and its left neighbor (in[i+1]) are both '1'
            // For i=99, no left neighbor, output zero
            if (i < 99) begin
                assign out_both[i] = in[i] & in[i + 1];
            end else begin
                assign out_both[i] = 1'b0;
            end

            // out_any[i]: Check if in[i] or its right neighbor (in[i-1]) is '1'
            // For i=0, no right neighbor, output zero
            if (i > 0) begin
                assign out_any[i] = in[i] | in[i - 1];
            end else begin
                assign out_any[i] = 1'b0;
            end

            // out_different[i]: XOR with left neighbor with wrap-around (in[(i-1) mod 100])
            assign out_different[i] = in[i] ^ in[(i + 99) % 100];
        end
    endgenerate

endmodule