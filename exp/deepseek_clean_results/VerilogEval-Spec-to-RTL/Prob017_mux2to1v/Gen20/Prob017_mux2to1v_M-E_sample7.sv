module TopModule (
    input  [99:0] a,
    input  [99:0] b,
    input         sel,
    output [99:0] out
);

    // Instantiate 25 4-bit 2:1 muxes
    genvar i;
    generate
        for (i = 0; i < 25; i = i + 1) begin : mux_array
            assign out[i*4 +: 4] = sel ? b[i*4 +: 4] : a[i*4 +: 4];
        end
    endgenerate

endmodule