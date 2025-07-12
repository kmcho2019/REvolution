module TopModule (
    input [99:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    // Slice the input into 10 segments of 10 bits each
    wire [9:0] slice_and [9:0];
    wire [9:0] slice_or  [9:0];
    wire [9:0] slice_xor [9:0];
    
    // First stage: Process each 10-bit slice in parallel
    genvar i;
    generate
        for (i = 0; i < 10; i = i + 1) begin : slice_processing
            assign slice_and[i] = &in[i*10 +: 10];
            assign slice_or[i]  = |in[i*10 +: 10];
            assign slice_xor[i] = ^in[i*10 +: 10];
        end
    endgenerate
    
    // Second stage: Combine slice results
    wire [9:0] and_intermediate;
    wire [9:0] or_intermediate;
    wire [9:0] xor_intermediate;
    
    assign and_intermediate = {slice_and[9], slice_and[8], slice_and[7], slice_and[6], slice_and[5],
                              slice_and[4], slice_and[3], slice_and[2], slice_and[1], slice_and[0]};
    
    assign or_intermediate = {slice_or[9], slice_or[8], slice_or[7], slice_or[6], slice_or[5],
                             slice_or[4], slice_or[3], slice_or[2], slice_or[1], slice_or[0]};
    
    assign xor_intermediate = {slice_xor[9], slice_xor[8], slice_xor[7], slice_xor[6], slice_xor[5],
                              slice_xor[4], slice_xor[3], slice_xor[2], slice_xor[1], slice_xor[0]};
    
    // Final reduction
    assign out_and = &and_intermediate;
    assign out_or  = |or_intermediate;
    assign out_xor = ^xor_intermediate;

endmodule