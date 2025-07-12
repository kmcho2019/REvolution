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
        else if (WIDTH == 1) begin : single_case
            assign out = in;
        end
        else begin : recursive_case
            localparam QUARTER_WIDTH = WIDTH / 4;
            wire [3:0] quarter_out;
            
            for (genvar i = 0; i < 4; i = i + 1) begin : quarter_muxes
                if (i < 3 || WIDTH % 4 == 0) begin : full_quarter
                    ParamMux4Way #(.WIDTH(QUARTER_WIDTH)) quarter_mux (
                        .in(in[(i+1)*QUARTER_WIDTH-1:i*QUARTER_WIDTH]),
                        .sel(sel[$clog2(QUARTER_WIDTH)-1:0]),
                        .out(quarter_out[i])
                    );
                end
                else begin : partial_quarter  // Handle non-power-of-4 widths
                    ParamMux4Way #(.WIDTH(WIDTH-3*QUARTER_WIDTH)) quarter_mux (
                        .in(in[WIDTH-1:3*QUARTER_WIDTH]),
                        .sel(sel[$clog2(WIDTH-3*QUARTER_WIDTH)-1:0]),
                        .out(quarter_out[i])
                    );
                end
            end
            
            // Top level 4:1 mux
            assign out = quarter_out[sel[$clog2(WIDTH)-1:$clog2(WIDTH)-2]];
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