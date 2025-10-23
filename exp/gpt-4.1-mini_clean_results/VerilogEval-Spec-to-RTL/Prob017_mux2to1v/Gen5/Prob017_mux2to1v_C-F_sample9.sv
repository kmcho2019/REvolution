module BitMuxNto1 #(
    parameter WIDTH = 10
)(
    input  wire [WIDTH-1:0] a,
    input  wire [WIDTH-1:0] b,
    input  wire             sel,
    output wire [WIDTH-1:0] out
);
    // Vectorized mux for the segment
    assign out = sel ? b : a;
endmodule

module TopModule (
    input  wire [99:0] a,
    input  wire [99:0] b,
    input  wire        sel,
    output wire [99:0] out
);
    localparam SEG_WIDTH = 10;
    localparam NUM_SEGS = 100 / SEG_WIDTH;

    genvar i;
    generate
        for (i = 0; i < NUM_SEGS; i = i + 1) begin : seg_muxes
            BitMuxNto1 #(.WIDTH(SEG_WIDTH)) seg_mux_inst (
                .a(a[i*SEG_WIDTH +: SEG_WIDTH]),
                .b(b[i*SEG_WIDTH +: SEG_WIDTH]),
                .sel(sel),
                .out(out[i*SEG_WIDTH +: SEG_WIDTH])
            );
        end
    endgenerate
endmodule