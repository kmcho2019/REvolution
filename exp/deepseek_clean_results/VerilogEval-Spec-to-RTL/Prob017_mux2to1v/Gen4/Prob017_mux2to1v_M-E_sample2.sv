module TopModule (
    input  [99:0] a,
    input  [99:0] b,
    input         sel,
    output [99:0] out
);

    // Generate 25 instances of 4-bit mux slices
    genvar i;
    generate
        for (i = 0; i < 25; i = i + 1) begin : mux_slice
            Mux4Bit mux (
                .a(a[i*4 +: 4]),
                .b(b[i*4 +: 4]),
                .sel(sel),
                .out(out[i*4 +: 4])
            );
        end
    endgenerate

endmodule

// 4-bit 2:1 mux submodule
module Mux4Bit (
    input  [3:0] a,
    input  [3:0] b,
    input        sel,
    output [3:0] out
);

    assign out = sel ? b : a;

endmodule