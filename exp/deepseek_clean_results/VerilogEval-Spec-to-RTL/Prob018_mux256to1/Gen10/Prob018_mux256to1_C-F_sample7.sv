module ParamMux #(
    parameter WIDTH = 16
) (
    input  [WIDTH-1:0] in,
    input  [$clog2(WIDTH)-1:0] sel,
    output out
);
    assign out = in[sel];
endmodule

module TopModule (
    input  [255:0] in,
    input  [7:0]   sel,
    output        out
);

    // Parameterized group size (16x16=256)
    localparam GROUPS = 16;
    localparam GROUP_WIDTH = 16;
    
    // First level: Select one group
    wire [GROUP_WIDTH-1:0] group_out [GROUPS-1:0];
    
    generate
        genvar i;
        for (i = 0; i < GROUPS; i = i + 1) begin : group_muxes
            // Instantiate parameterized mux for each group
            ParamMux #(.WIDTH(GROUP_WIDTH)) group_mux (
                .in(in[(i*GROUP_WIDTH)+GROUP_WIDTH-1 : i*GROUP_WIDTH]),
                .sel(sel[3:0]),
                .out(group_out[i])
            );
        end
    endgenerate
    
    // Second level: Select one group's output
    ParamMux #(.WIDTH(GROUPS)) final_mux (
        .in({group_out[15], group_out[14], group_out[13], group_out[12],
             group_out[11], group_out[10], group_out[9],  group_out[8],
             group_out[7],  group_out[6],  group_out[5],  group_out[4],
             group_out[3],  group_out[2],  group_out[1],  group_out[0]}),
        .sel(sel[7:4]),
        .out(out)
    );

endmodule