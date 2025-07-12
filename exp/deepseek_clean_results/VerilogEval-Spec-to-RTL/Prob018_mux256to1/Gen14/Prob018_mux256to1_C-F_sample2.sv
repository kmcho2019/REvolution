module ParamMux16Way #(
    parameter WIDTH = 256
) (
    input  [WIDTH-1:0] in,
    input  [$clog2(WIDTH)-1:0] sel,
    output out
);

    localparam GROUP_SIZE = 16;
    localparam NUM_GROUPS = WIDTH / GROUP_SIZE;
    
    generate
        if (WIDTH == GROUP_SIZE) begin : base_case
            assign out = in[sel];
        end
        else begin : recursive_case
            wire [GROUP_SIZE-1:0] group_outputs;
            
            for (genvar i = 0; i < NUM_GROUPS; i = i + 1) begin : group_muxes
                localparam LOWER = i * GROUP_SIZE;
                localparam UPPER = LOWER + GROUP_SIZE - 1;
                
                ParamMux16Way #(.WIDTH(GROUP_SIZE)) group_mux (
                    .in(in[UPPER:LOWER]),
                    .sel(sel[$clog2(GROUP_SIZE)-1:0]),
                    .out(group_outputs[i])
                );
            end
            
            assign out = group_outputs[sel[$clog2(WIDTH)-1:$clog2(GROUP_SIZE)]];
        end
    endgenerate
endmodule

module TopModule (
    input  [255:0] in,
    input  [7:0]   sel,
    output        out
);

    ParamMux16Way #(.WIDTH(256)) mux256 (
        .in(in),
        .sel(sel),
        .out(out)
    );

endmodule