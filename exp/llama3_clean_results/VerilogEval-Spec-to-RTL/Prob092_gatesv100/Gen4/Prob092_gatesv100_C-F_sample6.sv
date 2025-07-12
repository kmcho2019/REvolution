module TopModule(
    input [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

    genvar i;

    assign out_both[99] = 1'b0; // out_both[99] is always 0
    assign out_any[0] = 1'b0; // out_any[0] is always 0

    generate
        for (i = 0; i < 100; i++) begin
            if (i < 99) begin
                assign out_both[i] = in[i] & in[i+1];
            end
            if (i > 0) begin
                assign out_any[i] = in[i] | in[i-1];
            end
            assign out_different[i] = in[i] ^ in[(i+1)%100];
        end
    endgenerate

endmodule