module TopModule (
    input [99:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    // First stage: Process 10 slices of 10 bits each using reduction operators
    wire [9:0] slice_and;
    wire [9:0] slice_or;
    wire [9:0] slice_xor;
    
    genvar i;
    generate
        for (i = 0; i < 10; i = i + 1) begin : slice_processing
            assign slice_and[i] = &in[i*10 +: 10];  // 10-bit AND reduction
            assign slice_or[i]  = |in[i*10 +: 10];  // 10-bit OR reduction
            assign slice_xor[i] = ^in[i*10 +: 10];  // 10-bit XOR reduction
        end
    endgenerate

    // Second stage: Combine slice results using reduction operators
    assign out_and = &slice_and;  // AND all slice results
    assign out_or  = |slice_or;   // OR all slice results
    assign out_xor = ^slice_xor;  // XOR all slice results

endmodule