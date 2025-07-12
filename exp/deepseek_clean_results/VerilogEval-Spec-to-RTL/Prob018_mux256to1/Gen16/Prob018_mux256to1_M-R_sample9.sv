module MuxTree #(
    parameter WIDTH = 256
) (
    input  [WIDTH-1:0] in,
    input  [$clog2(WIDTH)-1:0] sel,
    output out
);

    wire [1:0] stage_out;
    
    // Base case for WIDTH=2
    assign stage_out[0] = sel[0] ? in[1] : in[0];
    
    // Recursive case for WIDTH>2
    generate
        if (WIDTH > 2) begin
            localparam HALF = WIDTH / 2;
            wire upper_out, lower_out;
            
            MuxTree #(HALF) upper (
                .in(in[WIDTH-1:HALF]),
                .sel(sel[$clog2(HALF)-1:0]),
                .out(upper_out)
            );
            
            MuxTree #(HALF) lower (
                .in(in[HALF-1:0]),
                .sel(sel[$clog2(HALF)-1:0]),
                .out(lower_out)
            );
            
            assign stage_out[1] = sel[$clog2(WIDTH)-1] ? upper_out : lower_out;
        end
    endgenerate
    
    assign out = (WIDTH == 2) ? stage_out[0] : stage_out[1];
endmodule

module TopModule (
    input  [255:0] in,
    input  [7:0]   sel,
    output        out
);

    MuxTree #(256) mux (
        .in(in),
        .sel(sel),
        .out(out)
    );

endmodule