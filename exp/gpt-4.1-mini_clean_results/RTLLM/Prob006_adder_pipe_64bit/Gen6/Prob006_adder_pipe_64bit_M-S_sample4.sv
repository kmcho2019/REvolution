module adder_pipe_64bit(
    input             clk,
    input             rst_n,
    input             i_en,
    input      [63:0] adda,
    input      [63:0] addb,
    output reg [64:0] result,
    output reg        o_en
);

    // Pipeline registers for carry signals between stages (5 stages: initial carry + 4 stages)
    reg [4:0] carry_pipe;
    // Pipeline registers for partial sums of each stage (4 stages of 16 bits each)
    reg [15:0] sum_pipe [3:0];
    // Enable pipeline stages to track valid data
    reg [4:0] en_pipe;

    integer i;

    // Wires for the addition result at each stage (16 bits + carry)
    wire [16:0] stage_sum [3:0];

    // Calculate each stage's sum using corresponding input slice and carry-in
    assign stage_sum[0] = {1'b0, adda[15:0]} + {1'b0, addb[15:0]} + carry_pipe[0];
    assign stage_sum[1] = {1'b0, adda[31:16]} + {1'b0, addb[31:16]} + carry_pipe[1];
    assign stage_sum[2] = {1'b0, adda[47:32]} + {1'b0, addb[47:32]} + carry_pipe[2];
    assign stage_sum[3] = {1'b0, adda[63:48]} + {1'b0, addb[63:48]} + carry_pipe[3];

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            carry_pipe <= 5'b0;
            en_pipe <= 5'b0;
            for (i = 0; i < 4; i = i + 1) begin
                sum_pipe[i] <= 16'd0;
            end
            result <= 65'd0;
            o_en <= 1'b0;
        end else begin
            // Shift enable signal through pipeline stages
            en_pipe[0] <= i_en;

            // Stage 0 carry-in is always zero (no initial carry)
            carry_pipe[0] <= 1'b0;

            // Stages 1 to 4 carry-ins come from previous stage sum carry-out
            carry_pipe[1] <= stage_sum[0][16];
            carry_pipe[2] <= stage_sum[1][16];
            carry_pipe[3] <= stage_sum[2][16];

            // Register partial sums from stage sums
            sum_pipe[0] <= stage_sum[0][15:0];
            sum_pipe[1] <= stage_sum[1][15:0];
            sum_pipe[2] <= stage_sum[2][15:0];
            sum_pipe[3] <= stage_sum[3][15:0];

            // Final carry-out is the carry from stage 3 sum
            carry_pipe[4] <= stage_sum[3][16];

            // Propagate enable down the pipeline
            en_pipe[1] <= en_pipe[0];
            en_pipe[2] <= en_pipe[1];
            en_pipe[3] <= en_pipe[2];
            en_pipe[4] <= en_pipe[3];

            // Concatenate result: final carry-out + all 4 partial sums
            result <= {carry_pipe[4], sum_pipe[3], sum_pipe[2], sum_pipe[1], sum_pipe[0]};
            o_en <= en_pipe[4];
        end
    end

endmodule