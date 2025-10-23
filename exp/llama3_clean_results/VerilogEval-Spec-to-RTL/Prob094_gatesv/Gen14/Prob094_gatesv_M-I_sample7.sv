module TopModule(
    input  [3:0] in,
    output [3:0] out_both,
    output [3:0] out_any,
    output [3:0] out_different
);

    genvar i;
    generate
        for (i = 0; i < 4; i++) begin
            assign out_both[i] = (i < 3) ? (in[i] & in[i+1]) : 1'b0;
            assign out_any[i] = in[i] | (i > 0 ? in[i-1] : 1'b0);
            assign out_different[i] = in[i] ^ in[(i+1)%4];
        end
    endgenerate

endmodule