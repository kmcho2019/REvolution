module TopModule (
    input  [99:0] a,
    input  [99:0] b,
    input         sel,
    output [99:0] out
    // Optional for power optimization:
    // input         en
);

    // Configurable group size - larger for better area/power
    localparam GROUP_SIZE = 20;
    localparam NUM_GROUPS = 100/GROUP_SIZE;
    
    // Parallel group muxing with larger groups
    genvar i;
    generate
        for (i = 0; i < NUM_GROUPS; i = i + 1) begin : mux_group
            assign out[i*GROUP_SIZE +: GROUP_SIZE] = 
                sel ? b[i*GROUP_SIZE +: GROUP_SIZE] 
                    : a[i*GROUP_SIZE +: GROUP_SIZE];
            
            // Optional power gating:
            // assign out[i*GROUP_SIZE +: GROUP_SIZE] = 
            //    en ? (sel ? b[i*GROUP_SIZE +: GROUP_SIZE] 
            //             : a[i*GROUP_SIZE +: GROUP_SIZE])
            //       : {GROUP_SIZE{1'b0}};
        end
    endgenerate

endmodule