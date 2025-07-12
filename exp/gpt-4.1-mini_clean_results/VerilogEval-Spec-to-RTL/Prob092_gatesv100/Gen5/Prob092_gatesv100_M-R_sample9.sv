module TopModule(
    input  wire [99:0] in,
    output wire [99:0] out_both,
    output wire [99:0] out_any,
    output wire [99:0] out_different
);

genvar i;
generate
    for (i = 0; i < 100; i = i + 1) begin : bit_logic
        // out_both[i]: both in[i] and neighbor to the left (in[i+1]) are 1
        // For i=99 no left neighbor, so 0
        if (i < 99) begin
            assign out_both[i] = in[i] & in[i + 1];
        end else begin
            assign out_both[i] = 1'b0;
        end

        // out_any[i]: any of in[i] and neighbor to the right (in[i-1]) is 1
        // For i=0 no right neighbor, so 0
        if (i > 0) begin
            assign out_any[i] = in[i] | in[i - 1];
        end else begin
            assign out_any[i] = 1'b0;
        end

        // out_different[i]: in[i] differs from neighbor to the left (with wrap)
        // Left neighbor of i=99 is in[0]; otherwise in[i+1]
        if (i < 99) begin
            assign out_different[i] = in[i] ^ in[i + 1];
        end else begin
            assign out_different[i] = in[i] ^ in[0];
        end
    end
endgenerate

endmodule