module ParamMuxBinary #(
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
            wire [1:0] half_outs;
            
            for (genvar i = 0; i < 2; i = i + 1) begin : half_muxes
                // Only enable the selected half to save power
                wire enable = (sel[$clog2(WIDTH)-1] == i);
                wire [HALF_WIDTH-1:0] half_in = enable ? in[(i+1)*HALF_WIDTH-1 : i*HALF_WIDTH] : {HALF_WIDTH{1'b0}};
                
                ParamMuxBinary #(.WIDTH(HALF_WIDTH)) half_mux (
                    .in(half_in),
                    .sel(sel[$clog2(HALF_WIDTH)-1:0]),
                    .out(half_outs[i])
                );
            end
            
            assign out = sel[$clog2(WIDTH)-1] ? half_outs[1] : half_outs[0];
        end
    endgenerate
endmodule

module TopModule (
    input  [255:0] in,
    input  [7:0]   sel,
    output        out
);

    // Alternative implementation using case statement for final optimization
    assign out = in[sel];

    // Or use the parameterized version if needed:
    // ParamMuxBinary #(.WIDTH(256)) mux256 (
    //     .in(in),
    //     .sel(sel),
    //     .out(out)
    // );

endmodule