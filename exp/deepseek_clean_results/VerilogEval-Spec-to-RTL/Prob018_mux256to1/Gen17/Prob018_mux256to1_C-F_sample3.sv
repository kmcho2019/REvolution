module ParamMux4WayOpt #(
    parameter WIDTH = 256
) (
    input  [WIDTH-1:0] in,
    input  [$clog2(WIDTH)-1:0] sel,
    output out
);

    generate
        if (WIDTH == 4) begin : base_case
            // Direct 4-to-1 mux for final level
            assign out = in[sel];
        end
        else begin : recursive_case
            localparam QUARTER_WIDTH = WIDTH / 4;
            wire [3:0] quarter_outs;
            wire [3:0] quarter_enables;
            
            // Generate enable signals for each quarter
            assign quarter_enables = (4'b1 << sel[$clog2(WIDTH)-1:$clog2(WIDTH)-2]);
            
            for (genvar i = 0; i < 4; i = i + 1) begin : quarter_muxes
                // Only instantiate active mux when enabled
                if (quarter_enables[i]) begin
                    ParamMux4WayOpt #(.WIDTH(QUARTER_WIDTH)) quarter_mux (
                        .in(in[(i+1)*QUARTER_WIDTH-1 : i*QUARTER_WIDTH]),
                        .sel(sel[$clog2(QUARTER_WIDTH)-1:0]),
                        .out(quarter_outs[i])
                    );
                end else begin
                    assign quarter_outs[i] = 1'b0;  // Power-optimized inactive path
                end
            end
            
            // Final selection from active quarters
            assign out = quarter_outs[sel[$clog2(WIDTH)-1:$clog2(WIDTH)-2]];
        end
    endgenerate
endmodule

module TopModule (
    input  [255:0] in,
    input  [7:0]   sel,
    output        out
);

    ParamMux4WayOpt #(.WIDTH(256)) mux256 (
        .in(in),
        .sel(sel),
        .out(out)
    );

endmodule