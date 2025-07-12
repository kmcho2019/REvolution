module TopModule (
    input        sel,
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] out
);

    // Instantiate 8 single-bit 2-to-1 muxes
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : mux_array
            Mux1bit mux_inst (
                .sel(sel),
                .a(a[i]),
                .b(b[i]),
                .out(out[i])
            );
        end
    endgenerate

endmodule

// Single-bit 2-to-1 mux module
module Mux1bit (
    input  sel,
    input  a,
    input  b,
    output out
);
    assign out = sel ? b : a;
endmodule