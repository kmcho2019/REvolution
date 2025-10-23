module ParamMux #(
    parameter WIDTH = 256
) (
    input  [WIDTH-1:0] in,
    input  [$clog2(WIDTH)-1:0] sel,
    output out
);

    localparam HALF_WIDTH = WIDTH / 2;
    
    wire upper_out = (WIDTH > 2) ? 
        ParamMux #(.WIDTH(HALF_WIDTH)) (
            .in(in[WIDTH-1:HALF_WIDTH]),
            .sel(sel[$clog2(HALF_WIDTH)-1:0]),
            .out(upper_out)
        ) : in[1];
    
    wire lower_out = (WIDTH > 2) ? 
        ParamMux #(.WIDTH(HALF_WIDTH)) (
            .in(in[HALF_WIDTH-1:0]),
            .sel(sel[$clog2(HALF_WIDTH)-1:0]),
            .out(lower_out)
        ) : in[0];
    
    assign out = (WIDTH > 1) ? 
        (sel[$clog2(WIDTH)-1] ? upper_out : lower_out) : in;
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