module TopModule (
    input  [99:0] a,
    input  [99:0] b,
    input         sel,
    output [99:0] out
);

    // Parameterized grouping for flexibility
    parameter GROUP_SIZE = 25;  // Default grouping based on good PPA results
    localparam NUM_GROUPS = 100/GROUP_SIZE;

    // Efficient flat implementation with parameterized grouping
    genvar i;
    generate
        for (i = 0; i < NUM_GROUPS; i = i + 1) begin : mux_group
            // Direct selection without intermediate wires
            assign out[i*GROUP_SIZE +: GROUP_SIZE] = 
                sel ? b[i*GROUP_SIZE +: GROUP_SIZE] : a[i*GROUP_SIZE +: GROUP_SIZE];
        end
    endgenerate

endmodule