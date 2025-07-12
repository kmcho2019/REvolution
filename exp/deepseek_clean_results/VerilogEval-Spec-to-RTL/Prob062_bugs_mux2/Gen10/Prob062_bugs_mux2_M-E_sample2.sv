// Single-bit 2-to-1 mux module
module BitMux (
    input  sel,
    input  a,
    input  b,
    output out
);
    assign out = sel ? b : a;
endmodule

// Top-level 8-bit mux using bit-sliced design
module TopModule (
    input        sel,
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] out
);

    // Generate 8 instances of the single-bit mux
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : MUX_SLICE
            BitMux bit_mux (
                .sel(sel),
                .a(a[i]),
                .b(b[i]),
                .out(out[i])
            );
        end
    endgenerate

endmodule