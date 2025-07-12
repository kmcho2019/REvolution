module TopModule (
    input        sel,
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] out
);

    // Implement 8 parallel 1-bit muxes
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : mux_array
            assign out[i] = sel ? b[i] : a[i];
        end
    endgenerate

endmodule