module TopModule (
    input [99:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    // First stage: Process 4 slices of 25 bits each using reduction operators
    wire [3:0] slice_and;
    wire [3:0] slice_or;
    wire [3:0] slice_xor;
    
    genvar i;
    generate
        for (i = 0; i < 4; i = i + 1) begin : slice_processing
            localparam hi = (i+1)*25-1;
            localparam lo = i*25;
            assign slice_and[i] = &in[hi:lo];
            assign slice_or[i]  = |in[hi:lo];
            assign slice_xor[i] = ^in[hi:lo];
        end
    endgenerate

    // Second stage: Combine slice results with explicit reduction for timing control
    assign out_and = &slice_and;
    assign out_or  = |slice_or;
    assign out_xor = ^slice_xor;

endmodule