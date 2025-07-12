module ParamMux8Way #(
    parameter WIDTH = 256
) (
    input  [WIDTH-1:0] in,
    input  [$clog2(WIDTH)-1:0] sel,
    output out
);

    localparam GROUP_SIZE = 8;
    localparam NUM_GROUPS = WIDTH / GROUP_SIZE;
    
    generate
        if (WIDTH == GROUP_SIZE) begin : base_case
            assign out = in[sel];
        end
        else begin : recursive_case
            wire [GROUP_SIZE-1:0] group_outputs;
            wire [NUM_GROUPS-1:0] group_enable;
            
            // Create enable signals for each group
            assign group_enable = (1 << sel[$clog2(WIDTH)-1:$clog2(WIDTH)-3]);
            
            for (genvar i = 0; i < NUM_GROUPS; i = i + 1) begin : group_muxes
                localparam LOWER = i * GROUP_SIZE;
                localparam UPPER = LOWER + GROUP_SIZE - 1;
                
                // Only activate the selected group
                if (i == 0) begin : first_group
                    ParamMux8Way #(.WIDTH(GROUP_SIZE)) group_mux (
                        .in(in[UPPER:LOWER]),
                        .sel(sel[$clog2(GROUP_SIZE)-1:0]),
                        .out(group_outputs[i])
                    );
                end
                else begin : other_groups
                    ParamMux8Way #(.WIDTH(GROUP_SIZE)) group_mux (
                        .in(group_enable[i] ? in[UPPER:LOWER] : {GROUP_SIZE{1'b0}}),
                        .sel(sel[$clog2(GROUP_SIZE)-1:0]),
                        .out(group_outputs[i])
                    );
                end
            end
            
            assign out = group_outputs[sel[$clog2(WIDTH)-1:$clog2(WIDTH)-3]];
        end
    endgenerate
endmodule

module TopModule (
    input  [255:0] in,
    input  [7:0]   sel,
    output        out
);

    ParamMux8Way #(.WIDTH(256)) mux256 (
        .in(in),
        .sel(sel),
        .out(out)
    );

endmodule