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
            localparam hi = (i+1)*10-1;
            localparam lo = i*10;
            assign slice_and[i] = &in[hi:lo];
            assign slice_or[i]  = |in[hi:lo];
            assign slice_xor[i] = ^in[hi:lo];
        end
    endgenerate

    // Second stage: Combine slice results with explicit reduction
    assign out_and = &slice_and;
    assign out_or  = |slice_or;
    assign out_xor = ^slice_xor;

endmodule