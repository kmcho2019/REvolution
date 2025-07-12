module TopModule (
    input        sel,
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] out
);

    // Generate 8 individual 1-bit 2-to-1 muxes
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : mux_array
            assign out[i] = sel ? b[i] : a[i];
        end
    endgenerate

endmodule