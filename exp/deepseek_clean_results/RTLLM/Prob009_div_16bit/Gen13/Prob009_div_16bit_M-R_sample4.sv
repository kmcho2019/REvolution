module div_16bit (
    input [15:0] A,
    input [7:0] B,
    output [15:0] result,
    output [15:0] odd
);

    // Intermediate wires for each stage
    wire [8:0] stage_rem [0:16];
    
    // Initialize first stage remainder
    assign stage_rem[16] = 9'b0;
    
    // Generate division stages
    genvar i;
    generate
        for (i = 15; i >= 0; i = i - 1) begin : div_stage
            // Current remainder with next dividend bit
            wire [8:0] shifted_rem = {stage_rem[i+1][7:0], A[i]};
            
            // Comparison and subtraction logic
            assign result[i] = (shifted_rem >= B);
            assign stage_rem[i] = result[i] ? (shifted_rem - B) : shifted_rem;
        end
    endgenerate

    // Final remainder output (16 bits, upper 8 bits zero)
    assign odd = {8'b0, stage_rem[0][7:0]};

endmodule