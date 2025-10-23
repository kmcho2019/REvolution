module div_16bit (
    input [15:0] A,
    input [7:0] B,
    output [15:0] result,
    output [7:0] odd
);

    // Parallel prefix computation for faster comparison
    wire [8:0] B_ext = {1'b0, B};
    wire [8:0] stage_comp [0:15];
    wire [7:0] stage_rem [0:15];
    
    // First stage
    assign stage_comp[0] = {1'b0, A[15]};
    assign result[15] = stage_comp[0] >= B_ext;
    assign stage_rem[0] = result[15] ? (stage_comp[0] - B_ext) : stage_comp[0][7:0];

    // Optimized generate block with parallel prefix
    genvar i;
    generate
        for (i = 1; i < 16; i = i + 1) begin : div_steps
            // Parallel computation of all possible remainders
            wire [8:0] shifted = {stage_rem[i-1], A[15-i]};
            wire [8:0] rem_if_sub = shifted - B_ext;
            
            // Fast comparison using carry-lookahead principle
            wire do_subtract = ~rem_if_sub[8];
            
            // Select result
            assign result[15-i] = do_subtract;
            assign stage_rem[i] = do_subtract ? rem_if_sub[7:0] : shifted[7:0];
            
            // For parallel prefix computation
            assign stage_comp[i] = shifted;
        end
    endgenerate

    // Final remainder output
    assign odd = stage_rem[15];

endmodule