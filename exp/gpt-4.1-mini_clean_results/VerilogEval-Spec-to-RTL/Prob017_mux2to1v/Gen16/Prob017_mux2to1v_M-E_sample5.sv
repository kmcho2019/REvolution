module TwoBitMux (
    input  wire [1:0] a,
    input  wire [1:0] b,
    input  wire       sel,
    output wire [1:0] out
);
    assign out = sel ? b : a;
endmodule

module TopModule (
    input  wire [99:0] a,
    input  wire [99:0] b,
    input  wire        sel,
    output wire [99:0] out
);

    // First level: mux 50 groups of 2 bits each from a and b
    wire [99:0] level0;
    genvar i;
    generate
        for (i = 0; i < 50; i = i + 1) begin : lvl0_muxes
            TwoBitMux mux_inst (
                .a   (a[2*i +: 2]),
                .b   (b[2*i +: 2]),
                .sel (sel),
                .out (level0[2*i +: 2])
            );
        end
    endgenerate

    // Subsequent levels just pass through level0 outputs directly since output width is constant
    // and selection already performed at level0.

    assign out = level0;

endmodule