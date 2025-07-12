module TopModule (
    input  [99:0] a,
    input  [99:0] b,
    input         sel,
    output [99:0] out
);

    genvar i;
    generate
        for (i = 0; i < 100; i = i + 1) begin : mux1bit
            assign out[i] = sel ? b[i] : a[i];
        end
    endgenerate

endmodule