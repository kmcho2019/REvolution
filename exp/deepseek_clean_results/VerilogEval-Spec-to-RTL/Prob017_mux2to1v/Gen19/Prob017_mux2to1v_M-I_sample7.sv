module TopModule (
    input  [99:0] a,
    input  [99:0] b,
    input         sel,
    output [99:0] out
);

    // Split into 4 segments of 25 bits each for better PPA
    genvar i;
    generate
        for (i = 0; i < 4; i = i + 1) begin : mux_segment
            assign out[i*25 +: 25] = sel ? b[i*25 +: 25] : a[i*25 +: 25];
        end
    endgenerate

endmodule