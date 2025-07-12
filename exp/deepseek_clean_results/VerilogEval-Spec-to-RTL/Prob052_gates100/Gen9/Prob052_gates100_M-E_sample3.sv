module TopModule (
    input [99:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    // First stage: Process 10 slices of 10 bits each
    wire [9:0] slice_and;
    wire [9:0] slice_or;
    wire [9:0] slice_xor;
    
    genvar i;
    generate
        for (i = 0; i < 10; i = i + 1) begin : slice_processing
            // Process 10 bits per slice
            assign slice_and[i] = &in[i*10 +: 10];
            assign slice_or[i]  = |in[i*10 +: 10];
            assign slice_xor[i] = ^in[i*10 +: 10];
        end
    endgenerate

    // Second stage: Combine slice results
    // AND: All slices must be 1
    assign out_and = &slice_and;
    
    // OR: Any slice must be 1
    assign out_or = |slice_or;
    
    // XOR: XOR all slice results
    assign out_xor = ^slice_xor;

endmodule