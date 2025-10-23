module TreeMux #(
    parameter WIDTH = 256,
    parameter FANOUT = 4  // Configurable fanout (2,4,8,...)
) (
    input  [WIDTH-1:0] in,
    input  [$clog2(WIDTH)-1:0] sel,
    output out
);
    
    localparam LEVELS = $clog2(WIDTH)/$clog2(FANOUT) + 
                       (($clog2(WIDTH)%$clog2(FANOUT)) ? 1 : 0;
    
    // Intermediate wires between levels
    wire [FANOUT**LEVELS-1:0] stage [0:LEVELS];
    assign stage[0] = in;
    
    genvar l, b;
    generate
        for (l = 0; l < LEVELS; l = l + 1) begin : level
            localparam PREV_WIDTH = (l == 0) ? WIDTH : (FANOUT**(l));
            localparam GROUPS = (PREV_WIDTH + FANOUT - 1) / FANOUT;
            
            for (b = 0; b < GROUPS; b = b + 1) begin : block
                localparam GROUP_WIDTH = (b == GROUPS-1) ? 
                    PREV_WIDTH - b*FANOUT : FANOUT;
                
                // Select relevant bits from previous stage
                wire [GROUP_WIDTH-1:0] prev_bits = 
                    stage[l][b*FANOUT +: GROUP_WIDTH];
                
                // Select relevant control bits
                wire [$clog2(FANOUT)-1:0] lvl_sel = 
                    sel[l*$clog2(FANOUT) +: $clog2(FANOUT)];
                
                // Create small mux for this group
                assign stage[l+1][b] = prev_bits[lvl_sel];
            end
        end
    endgenerate
    
    assign out = stage[LEVELS][0];
endmodule

module TopModule (
    input  [255:0] in,
    input  [7:0]   sel,
    output        out
);

    TreeMux #(.WIDTH(256), .FANOUT(4)) mux256 (
        .in(in),
        .sel(sel),
        .out(out)
    );

endmodule