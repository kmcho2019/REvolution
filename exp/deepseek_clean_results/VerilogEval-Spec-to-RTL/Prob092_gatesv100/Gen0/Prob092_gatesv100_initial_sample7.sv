module TopModule (
    input [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

    // out_both calculation
    assign out_both[99] = 1'b0;
    genvar i;
    generate
        for (i = 0; i < 99; i = i + 1) begin : both_loop
            assign out_both[i] = in[i] & in[i+1];
        end
    endgenerate

    // out_any calculation
    assign out_any[0] = 1'b0;
    generate
        for (i = 1; i < 100; i = i + 1) begin : any_loop
            assign out_any[i] = in[i] | in[i-1];
        end
    endgenerate

    // out_different calculation (with wrap-around)
    generate
        for (i = 0; i < 100; i = i + 1) begin : diff_loop
            assign out_different[i] = in[i] ^ in[(i == 0) ? 99 : (i-1)];
        end
    endgenerate

endmodule