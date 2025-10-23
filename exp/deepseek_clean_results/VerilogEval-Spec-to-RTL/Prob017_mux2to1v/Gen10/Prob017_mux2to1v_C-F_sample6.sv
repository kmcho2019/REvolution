module TopModule #(
    parameter GROUP_SIZE = 100  // Default to no grouping, can be adjusted as needed
) (
    input  [99:0] a,
    input  [99:0] b,
    input         sel,
    output [99:0] out
);

    // Calculate number of groups needed
    localparam NUM_GROUPS = (99/GROUP_SIZE) + 1;
    
    // Use generate block only if grouping is needed (GROUP_SIZE < 100)
    generate
        if (GROUP_SIZE >= 100) begin : no_grouping
            // Simple case - no grouping needed
            assign out = sel ? b : a;
        end
        else begin : with_grouping
            // Grouped implementation for better fanout control
            wire [GROUP_SIZE-1:0] out_groups [0:NUM_GROUPS-1];
            
            for (genvar i = 0; i < NUM_GROUPS; i = i + 1) begin : mux_group
                localparam HIGH_BIT = (i*GROUP_SIZE + GROUP_SIZE-1) > 99 ? 99 : (i*GROUP_SIZE + GROUP_SIZE-1);
                localparam LOW_BIT = i*GROUP_SIZE;
                
                assign out_groups[i] = sel ? b[HIGH_BIT:LOW_BIT] : a[HIGH_BIT:LOW_BIT];
            end
            
            // Combine outputs
            assign out = {>>{out_groups}};
        end
    endgenerate

endmodule