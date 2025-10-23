module TopModule (
    input  [99:0] a,
    input  [99:0] b,
    input         sel,
    output [99:0] out
);

    genvar i;
    generate
        for (i = 0; i < 5; i = i + 1) begin : mux_group
            assign out[i*20 +: 20] = sel ? b[i*20 +: 20] : a[i*20 +: 20];
        end
    endgenerate

endmodule