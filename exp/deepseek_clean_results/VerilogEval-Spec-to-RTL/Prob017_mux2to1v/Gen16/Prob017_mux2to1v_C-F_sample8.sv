module TopModule (
    input  [99:0] a,
    input  [99:0] b,
    input         sel,
    output [99:0] out
);

    // Optimal group size for balanced fanout and timing
    localparam GROUP_SIZE = 10;
    localparam NUM_GROUPS = 100/GROUP_SIZE;
    
    // Parallel group muxing for optimal timing/power balance
    genvar i;
    generate
        for (i = 0; i < NUM_GROUPS; i = i + 1) begin : mux_group
            assign out[i*GROUP_SIZE +: GROUP_SIZE] = 
                sel ? b[i*GROUP_SIZE +: GROUP_SIZE] 
                    : a[i*GROUP_SIZE +: GROUP_SIZE];
        end
    endgenerate

endmodule