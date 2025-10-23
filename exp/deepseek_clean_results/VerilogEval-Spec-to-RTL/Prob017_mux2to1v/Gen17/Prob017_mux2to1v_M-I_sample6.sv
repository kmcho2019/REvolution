module TopModule (
    input  [99:0] a,
    input  [99:0] b,
    input         sel,
    output [99:0] out
);

    // Direct implementation with 25 parallel 4-bit muxes
    genvar i;
    generate
        for (i = 0; i < 25; i = i + 1) begin : mux4bit
            assign out[i*4 +: 4] = sel ? b[i*4 +: 4] : a[i*4 +: 4];
        end
    endgenerate

endmodule