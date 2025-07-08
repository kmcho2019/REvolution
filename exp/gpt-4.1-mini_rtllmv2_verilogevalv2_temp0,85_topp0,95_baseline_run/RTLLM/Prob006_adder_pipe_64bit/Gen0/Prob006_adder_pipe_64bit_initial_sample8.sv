module adder_pipe_64bit (
    input               clk,
    input               rst_n,
    input               i_en,
    input      [63:0]   adda,
    input      [63:0]   addb,
    output reg [64:0]   result,
    output reg          o_en
);

// Pipeline depth: 8 stages, each handles 8 bits addition + carry

// Pipeline registers for operands and carry
reg [7:0]  stage_adda [0:7];
reg [7:0]  stage_addb [0:7];
reg        stage_cin  [0:7];  // carry in for each stage

// Pipeline registers for sums
reg [7:0]  stage_sum  [0:7];

// Pipeline registers for enable signals
reg        en_pipe [0:7];

// Internal carry wires for addition in each stage
wire [8:0] stage_sum_w [0:7];

// Stage 0 carry-in is zero for each addition
// We will propagate carry through the pipeline registers

integer i;

// Combinational addition for each stage
assign stage_sum_w[0] = {1'b0, stage_adda[0]} + {1'b0, stage_addb[0]} + stage_cin[0];
assign stage_sum_w[1] = {1'b0, stage_adda[1]} + {1'b0, stage_addb[1]} + stage_cin[1];
assign stage_sum_w[2] = {1'b0, stage_adda[2]} + {1'b0, stage_addb[2]} + stage_cin[2];
assign stage_sum_w[3] = {1'b0, stage_adda[3]} + {1'b0, stage_addb[3]} + stage_cin[3];
assign stage_sum_w[4] = {1'b0, stage_adda[4]} + {1'b0, stage_addb[4]} + stage_cin[4];
assign stage_sum_w[5] = {1'b0, stage_adda[5]} + {1'b0, stage_addb[5]} + stage_cin[5];
assign stage_sum_w[6] = {1'b0, stage_adda[6]} + {1'b0, stage_addb[6]} + stage_cin[6];
assign stage_sum_w[7] = {1'b0, stage_adda[7]} + {1'b0, stage_addb[7]} + stage_cin[7];

// Pipeline register update
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Clear pipeline registers
        for (i = 0; i < 8; i = i + 1) begin
            stage_adda[i] <= 8'b0;
            stage_addb[i] <= 8'b0;
            stage_sum[i]  <= 8'b0;
            stage_cin[i]  <= 1'b0;
            en_pipe[i]    <= 1'b0;
        end
        result <= 65'b0;
        o_en <= 1'b0;
    end else begin
        // Shift enable pipeline
        en_pipe[0] <= i_en;
        for (i = 1; i < 8; i = i + 1) begin
            en_pipe[i] <= en_pipe[i-1];
        end

        // Stage 0 input load when i_en is asserted
        if (i_en) begin
            stage_adda[0] <= adda[7:0];
            stage_addb[0] <= addb[7:0];
            stage_cin[0]  <= 1'b0; // no carry-in to first stage
        end else begin
            // Hold values if i_en is low
            stage_adda[0] <= stage_adda[0];
            stage_addb[0] <= stage_addb[0];
            stage_cin[0]  <= stage_cin[0];
        end

        // For stages 1 to 7:
        // Register the sum and carry-out from previous stage as inputs
        for (i = 1; i < 8; i = i + 1) begin
            if (en_pipe[i-1]) begin
                stage_adda[i] <= adda[8*i +: 8];
                stage_addb[i] <= addb[8*i +: 8];
                stage_cin[i]  <= stage_sum_w[i-1][8];  // carry out from previous stage
            end else begin
                // hold
                stage_adda[i] <= stage_adda[i];
                stage_addb[i] <= stage_addb[i];
                stage_cin[i]  <= stage_cin[i];
            end
        end

        // Register sum output for each stage when enable is valid
        for (i = 0; i < 8; i = i + 1) begin
            if (en_pipe[i]) begin
                stage_sum[i] <= stage_sum_w[i][7:0];
            end else begin
                stage_sum[i] <= stage_sum[i];
            end
        end

        // Final output valid when last stage enable is asserted
        if (en_pipe[7]) begin
            // Concatenate all stage sums + last carry out bit
            result <= {stage_sum_w[7][8],
                       stage_sum[7],
                       stage_sum[6],
                       stage_sum[5],
                       stage_sum[4],
                       stage_sum[3],
                       stage_sum[2],
                       stage_sum[1],
                       stage_sum[0]};
            o_en <= 1'b1;
        end else begin
            o_en <= 1'b0;
            // Keep result stable when no new valid sum
            result <= result;
        end
    end
end

endmodule