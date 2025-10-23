module TopModule (
    input [99:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    // Parameters for hierarchical processing
    localparam SLICE_SIZE = 10;
    localparam NUM_SLICES = 10;
    
    // First stage: Process 10 slices of 10 bits each using reduction operators
    wire [NUM_SLICES-1:0] slice_and;
    wire [NUM_SLICES-1:0] slice_or;
    wire [NUM_SLICES-1:0] slice_xor;
    
    genvar i;
    generate
        for (i = 0; i < NUM_SLICES; i = i + 1) begin : slice_processing
            // Current slice
            wire [SLICE_SIZE-1:0] current_slice = in[i*SLICE_SIZE +: SLICE_SIZE];
            
            // Slice reductions using built-in operators
            assign slice_and[i] = &current_slice;
            assign slice_or[i]  = |current_slice;
            assign slice_xor[i] = ^current_slice;
        end
    endgenerate

    // Second stage: Combine slice results using reduction operators
    assign out_and = &slice_and;  // All slices must be 1
    assign out_or  = |slice_or;   // Any slice must be 1
    assign out_xor = ^slice_xor;  // XOR all slice results

endmodule