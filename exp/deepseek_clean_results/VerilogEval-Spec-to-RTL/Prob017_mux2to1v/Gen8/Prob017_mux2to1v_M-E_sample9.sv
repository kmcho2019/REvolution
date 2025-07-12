module TopModule (
    input  [99:0] a,
    input  [99:0] b,
    input         sel,
    output [99:0] out
);

    // Generate 10 instances of 10-bit muxes
    genvar i;
    generate
        for (i = 0; i < 10; i = i + 1) begin : mux_group
            assign out[i*10 +: 10] = sel ? b[i*10 +: 10] : a[i*10 +: 10];
        end
    endgenerate

endmodule