module TopModule (
    input  [99:0] a,
    input  [99:0] b,
    input         sel,
    output [99:0] out
);

    // Optimal group size for balanced fanout and timing
    localparam GROUP_SIZE = 16;
    localparam NUM_GROUPS = (100 + GROUP_SIZE - 1) / GROUP_SIZE; // Ceiling division
    
    // Parallel group processing with bitwise operations
    genvar i;
    generate
        for (i = 0; i < NUM_GROUPS; i = i + 1) begin : mux_group
            localparam HIGH_BIT = (i == NUM_GROUPS-1) ? 99 : (i+1)*GROUP_SIZE-1;
            localparam BITS_IN_GROUP = HIGH_BIT - i*GROUP_SIZE + 1;
            
            wire [BITS_IN_GROUP-1:0] mask = {BITS_IN_GROUP{sel}};
            assign out[i*GROUP_SIZE +: BITS_IN_GROUP] = 
                (~mask & a[i*GROUP_SIZE +: BITS_IN_GROUP]) | 
                (mask & b[i*GROUP_SIZE +: BITS_IN_GROUP]);
        end
    endgenerate

    /* Implementation Notes:
     * 1. 16-bit groups provide good fanout control while maintaining parallelism
     * 2. Bitwise operations reduce glitching compared to conditional operators
     * 3. Automatic handling of last partial group (when width not multiple of GROUP_SIZE)
     * 4. Clean parameterization allows easy adjustment of GROUP_SIZE
     * 5. Synthesis tools can optimize this into efficient pass-gate or AOI logic
     */
endmodule