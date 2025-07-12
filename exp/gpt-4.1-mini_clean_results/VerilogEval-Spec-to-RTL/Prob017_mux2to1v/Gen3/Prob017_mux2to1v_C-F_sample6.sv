module BitMux2to1(
    input  wire a,
    input  wire b,
    input  wire sel,
    output wire out
);
    assign out = sel ? b : a;
endmodule

module VectorMux2to1_10bit(
    input  wire [9:0] a,
    input  wire [9:0] b,
    input  wire       sel,
    output wire [9:0] out
);
    // Vectorized mux for 10 bits
    assign out = sel ? b : a;
endmodule

module TopModule(
    input  wire [99:0] a,
    input  wire [99:0] b,
    input  wire        sel,
    output wire [99:0] out
);
    genvar i;
    generate
        // Instantiate 10 blocks of 10-bit vector muxes
        for (i = 0; i < 10; i = i + 1) begin : vector_mux_blocks
            VectorMux2to1_10bit vmux (
                .a(a[10*i +: 10]),
                .b(b[10*i +: 10]),
                .sel(sel),
                .out(out[10*i +: 10])
            );
        end
    endgenerate
endmodule