module div_16bit (
    input [15:0] A,
    input [7:0] B,
    output [15:0] result,
    output [7:0] odd
);

    wire [15:0] quotient;
    wire [7:0] final_remainder;
    
    // Processing stages
    wire [8:0] stage_out [0:15];
    wire [7:0] stage_remainder [0:15];
    
    // First stage
    wire [8:0] first_in = {1'b0, A[15]};
    assign quotient[15] = (first_in >= B);
    assign stage_out[0] = quotient[15] ? (first_in - B) : first_in;
    
    // Intermediate stages
    genvar i;
    generate
        for (i = 14; i >= 0; i = i - 1) begin : div_stage
            wire [8:0] current_in = {stage_out[14-i][7:0], A[i]};
            
            // Optimized comparison: start from MSB
            wire gt = 1'b0;
            wire eq = 1'b1;
            integer j;
            always @(*) begin
                for (j = 7; j >= 0; j = j - 1) begin
                    if (!eq) continue;
                    if (current_in[j+1] > B[j]) begin
                        gt = 1'b1;
                        eq = 1'b0;
                    end
                    else if (current_in[j+1] < B[j]) begin
                        gt = 1'b0;
                        eq = 1'b0;
                    end
                end
            end
            
            assign quotient[i] = gt || (eq && (current_in[0] >= B[0]));
            assign stage_out[14-i+1] = quotient[i] ? (current_in - B) : current_in;
            
            // Early termination if remainder is zero
            if (i > 0) begin
                assign stage_remainder[14-i+1] = (|stage_out[14-i+1]) ? stage_out[14-i+1][7:0] : 8'b0;
            end
        end
    endgenerate
    
    // Final outputs
    assign result = quotient;
    assign odd = stage_out[15][7:0];

endmodule