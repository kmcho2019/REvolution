module TopModule #(
    parameter WIDTH = 256
) (
    input  [WIDTH-1:0] in,
    input  [$clog2(WIDTH)-1:0] sel,
    output out
);

    // Direct bit selection - most efficient implementation
    assign out = in[sel];

endmodule

// Instance with 256-bit width
module TopModule_256 (
    input  [255:0] in,
    input  [7:0]   sel,
    output        out
);

    TopModule #(.WIDTH(256)) mux (
        .in(in),
        .sel(sel),
        .out(out)
    );

endmodule