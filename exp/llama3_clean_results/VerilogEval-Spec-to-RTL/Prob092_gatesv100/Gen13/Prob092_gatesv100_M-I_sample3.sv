module TopModule(
    input [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

    genvar i;
    generate
        for (i = 0; i < 100; i++) begin
            assign out_both[i] = (i < 99) ? in[i] & in[i+1] : 1'b0;
            assign out_any[i] = (i > 0) ? in[i] | in[i-1] : 1'b0;
            assign out_different[i] = in[i] ^ ((i == 99) ? in[0] : in[i+1]);
        end
    endgenerate

endmodule