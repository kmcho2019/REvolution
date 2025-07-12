module ParamMux #(
    parameter WIDTH = 256
) (
    input  [WIDTH-1:0] in,
    input  [$clog2(WIDTH)-1:0] sel,
    output out
);

    generate
        if (WIDTH == 2) begin : base_case
            assign out = sel[0] ? in[1] : in[0];
        end
        else begin : recursive_case
            localparam HALF_WIDTH = WIDTH / 2;
            wire upper_out, lower_out;
            
            ParamMux #(.WIDTH(HALF_WIDTH)) upper_mux (
                .in(in[WIDTH-1:HALF_WIDTH]),
                .sel(sel[$clog2(HALF_WIDTH)-1:0]),
                .out(upper_out)
            );
            
            ParamMux #(.WIDTH(HALF_WIDTH)) lower_mux (
                .in(in[HALF_WIDTH-1:0]),
                .sel(sel[$clog2(HALF_WIDTH)-1:0]),
                .out(lower_out)
            );
            
            assign out = sel[$clog2(WIDTH)-1] ? upper_out : lower_out;
        end
    endgenerate
endmodule

module TopModule (
    input  [255:0] in,
    input  [7:0]   sel,
    output        out
);

    ParamMux #(.WIDTH(256)) mux256 (
        .in(in),
        .sel(sel),
        .out(out)
    );

endmodule