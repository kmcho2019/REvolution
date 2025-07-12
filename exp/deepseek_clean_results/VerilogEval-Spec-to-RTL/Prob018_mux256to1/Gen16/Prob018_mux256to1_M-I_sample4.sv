module QuadMux #(
    parameter WIDTH = 256
) (
    input  [WIDTH-1:0] in,
    input  [$clog2(WIDTH)-1:0] sel,
    output out
);

    generate
        if (WIDTH == 4) begin : base_case
            assign out = in[sel[1:0]];
        end
        else begin : recursive_case
            localparam QUAD_WIDTH = WIDTH / 4;
            wire [3:0] quad_out;
            
            for (genvar i = 0; i < 4; i = i + 1) begin : quad_muxes
                QuadMux #(.WIDTH(QUAD_WIDTH)) mux (
                    .in(in[(i+1)*QUAD_WIDTH-1:i*QUAD_WIDTH]),
                    .sel(sel[$clog2(QUAD_WIDTH)-1:0]),
                    .out(quad_out[i])
                );
            end
            
            assign out = quad_out[sel[$clog2(WIDTH)-1:$clog2(WIDTH)-2]];
        end
    endgenerate
endmodule

module TopModule (
    input  [255:0] in,
    input  [7:0]   sel,
    output        out
);

    QuadMux #(.WIDTH(256)) mux256 (
        .in(in),
        .sel(sel),
        .out(out)
    );

endmodule