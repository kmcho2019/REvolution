module TopModule(
    input [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

    genvar i;
    generate
        for (i = 0; i < 100; i = i + 1) begin
            // out_both calculation
            assign out_both[i] = (i == 99) ? 1'b0 : (in[i] & in[i+1]);

            // out_any calculation
            assign out_any[i] = (i == 0) ? 1'b0 : (in[i] | in[i-1]);

            // out_different calculation with wrap-around
            assign out_different[i] = in[i] ^ in[(i+1)%100];
        end
    endgenerate

endmodule