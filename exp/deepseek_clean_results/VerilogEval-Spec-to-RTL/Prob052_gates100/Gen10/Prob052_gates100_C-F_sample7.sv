module TopModule (
    input [99:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    // First stage: Process 10 slices of 10 bits each with explicit reduction
    wire [9:0] slice_and;
    wire [9:0] slice_or;
    wire [9:0] slice_xor;
    
    genvar i, j;
    generate
        for (i = 0; i < 10; i = i + 1) begin : slice_processing
            // AND reduction for each slice
            wire [9:0] and_intermediate;
            assign and_intermediate[0] = in[i*10];
            for (j = 1; j < 10; j = j + 1) begin : and_chain
                assign and_intermediate[j] = and_intermediate[j-1] & in[i*10 + j];
            end
            assign slice_and[i] = and_intermediate[9];
            
            // OR reduction for each slice
            wire [9:0] or_intermediate;
            assign or_intermediate[0] = in[i*10];
            for (j = 1; j < 10; j = j + 1) begin : or_chain
                assign or_intermediate[j] = or_intermediate[j-1] | in[i*10 + j];
            end
            assign slice_or[i] = or_intermediate[9];
            
            // XOR reduction for each slice
            wire [9:0] xor_intermediate;
            assign xor_intermediate[0] = in[i*10];
            for (j = 1; j < 10; j = j + 1) begin : xor_chain
                assign xor_intermediate[j] = xor_intermediate[j-1] ^ in[i*10 + j];
            end
            assign slice_xor[i] = xor_intermediate[9];
        end
    endgenerate

    // Second stage: Combine slice results
    // AND: All slices must be 1 (using explicit reduction)
    wire [9:0] final_and;
    assign final_and[0] = slice_and[0];
    generate
        for (i = 1; i < 10; i = i + 1) begin : final_and_chain
            assign final_and[i] = final_and[i-1] & slice_and[i];
        end
    endgenerate
    assign out_and = final_and[9];
    
    // OR: Any slice must be 1 (using explicit reduction)
    wire [9:0] final_or;
    assign final_or[0] = slice_or[0];
    generate
        for (i = 1; i < 10; i = i + 1) begin : final_or_chain
            assign final_or[i] = final_or[i-1] | slice_or[i];
        end
    endgenerate
    assign out_or = final_or[9];
    
    // XOR: XOR all slice results (using explicit reduction)
    wire [9:0] final_xor;
    assign final_xor[0] = slice_xor[0];
    generate
        for (i = 1; i < 10; i = i + 1) begin : final_xor_chain
            assign final_xor[i] = final_xor[i-1] ^ slice_xor[i];
        end
    endgenerate
    assign out_xor = final_xor[9];

endmodule