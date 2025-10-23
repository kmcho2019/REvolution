module TopModule(
    input [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

    assign out_both[99] = 0;
    assign out_any[0] = 0;

    genvar i;
    generate
        for (i = 0; i < 99; i++) begin
            assign out_both[i] = in[i] & in[i+1];
        end
        for (i = 1; i < 100; i++) begin
            assign out_any[i] = in[i] | in[i-1];
        end
        for (i = 0; i < 100; i++) begin
            assign out_different[i] = in[i] != in[(i+1)%100];
        end
    endgenerate

endmodule