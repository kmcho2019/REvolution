module ParamMux #(
    parameter WIDTH = 256,
    parameter FANOUT = 4
) (
    input  [WIDTH-1:0] in,
    input  [$clog2(WIDTH)-1:0] sel,
    output out
);

    generate
        if (WIDTH <= FANOUT) begin : leaf_case
            // Base case: direct selection
            assign out = in[sel];
        end
        else begin : tree_case
            localparam CHUNK_SIZE = WIDTH / FANOUT;
            wire [FANOUT-1:0] chunk_out;
            
            // Generate FANOUT parallel muxes
            for (genvar i = 0; i < FANOUT; i = i + 1) begin : mux_level
                ParamMux #(
                    .WIDTH(CHUNK_SIZE),
                    .FANOUT(FANOUT)
                ) sub_mux (
                    .in(in[(i+1)*CHUNK_SIZE-1 : i*CHUNK_SIZE]),
                    .sel(sel[$clog2(CHUNK_SIZE)-1:0]),
                    .out(chunk_out[i])
                );
            end
            
            // Top level selection
            assign out = chunk_out[sel[$clog2(WIDTH)-1:$clog2(CHUNK_SIZE)]];
        end
    endgenerate
endmodule

module TopModule (
    input  [255:0] in,
    input  [7:0]   sel,
    output        out
);

    ParamMux #(
        .WIDTH(256),
        .FANOUT(4)
    ) mux256 (
        .in(in),
        .sel(sel),
        .out(out)
    );

endmodule