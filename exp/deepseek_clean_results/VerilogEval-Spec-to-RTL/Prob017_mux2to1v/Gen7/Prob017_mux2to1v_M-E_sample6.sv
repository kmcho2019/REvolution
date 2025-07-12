module TopModule (
    input  [99:0] a,
    input  [99:0] b,
    input         sel,
    output [99:0] out
);

    // Parameter for grouping bits
    parameter GROUP_SIZE = 10;
    localparam NUM_GROUPS = 100/GROUP_SIZE;

    // Hierarchical mux implementation
    genvar i;
    generate
        for (i = 0; i < NUM_GROUPS; i = i + 1) begin : group_mux
            // Select the entire group first
            wire group_sel;
            assign group_sel = sel;
            
            // Then select within the group
            assign out[i*GROUP_SIZE +: GROUP_SIZE] = 
                group_sel ? b[i*GROUP_SIZE +: GROUP_SIZE] : a[i*GROUP_SIZE +: GROUP_SIZE];
        end
    endgenerate

endmodule