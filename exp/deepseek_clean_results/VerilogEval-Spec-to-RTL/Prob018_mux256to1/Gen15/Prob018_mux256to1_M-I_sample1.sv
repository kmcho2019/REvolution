module ParamMux4Way #(
    parameter WIDTH = 256
) (
    input  [WIDTH-1:0] in,
    input  [$clog2(WIDTH)-1:0] sel,
    output out
);

    generate
        if (WIDTH == 4) begin : base_case
            assign out = in[sel];
        end
        else begin : recursive_case
            localparam QUARTER_WIDTH = WIDTH / 4;
            wire [3:0] quarter_outs;
            
            for (genvar i = 0; i < 4; i = i + 1) begin : quarter_muxes
                ParamMux4Way #(.WIDTH(QUARTER_WIDTH)) quarter_mux (
                    .in(in[(i+1)*QUARTER_WIDTH-1 : i*QUARTER_WIDTH]),
                    .sel(sel[$clog2(QUARTER_WIDTH)-1:0]),
                    .out(quarter_outs[i])
                );
            end
            
            assign out = quarter_outs[sel[$clog2(WIDTH)-1:$clog2(WIDTH)-2]];
        end
    endgenerate
endmodule

module TopModule (
    input  [255:0] in,
    input  [7:0]   sel,
    output        out
);

    ParamMux4Way #(.WIDTH(256)) mux256 (
        .in(in),
        .sel(sel),
        .out(out)
    );

endmodule