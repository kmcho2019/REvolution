module TopModule(
    input  [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

    genvar i;

    generate
        for (i = 0; i < 100; i++) begin
            logic left, right;
            assign left = (i == 99) ? in[0] : in[i+1];
            assign right = (i == 0) ? 1'b0 : in[i-1];
            assign out_both[i] = in[i] & ((i < 99) ? in[i+1] : 1'b0);
            assign out_any[i] = in[i] | right;
            assign out_different[i] = in[i] ^ left;
        end
    endgenerate

endmodule