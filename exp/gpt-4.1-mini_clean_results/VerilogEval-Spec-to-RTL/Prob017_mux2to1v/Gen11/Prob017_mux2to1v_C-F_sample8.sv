module ChunkMux2to1_10bit(
    input  wire [9:0] a,
    input  wire [9:0] b,
    input  wire       sel,
    output wire [9:0] out
);
    // 10-bit wide 2-to-1 multiplexer
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
        for (i = 0; i < 10; i = i + 1) begin : chunk_muxes
            ChunkMux2to1_10bit chunk_mux_inst(
                .a   (a[i*10 +: 10]),
                .b   (b[i*10 +: 10]),
                .sel (sel),
                .out (out[i*10 +: 10])
            );
        end
    endgenerate
endmodule