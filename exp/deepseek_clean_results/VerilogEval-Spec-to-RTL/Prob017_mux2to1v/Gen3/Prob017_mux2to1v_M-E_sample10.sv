module TopModule (
    input  [99:0] a,
    input  [99:0] b,
    input        sel,
    output [99:0] out
);

    // Implement as 20 segments of 5-bit muxes
    genvar i;
    generate
        for (i = 0; i < 20; i = i + 1) begin : mux_segment
            assign out[i*5 +: 5] = sel ? b[i*5 +: 5] : a[i*5 +: 5];
        end
    endgenerate

endmodule