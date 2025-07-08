module adder_pipe_64bit (
    input             clk,
    input             rst_n,
    input             i_en,
    input      [63:0] adda,
    input      [63:0] addb,
    output reg [64:0] result,
    output reg        o_en
);

    // Number of pipeline stages
    localparam STAGES = 8;
    localparam STAGE_BITS = 8;

    // Pipeline registers for operands
    reg [63:0] adda_pipe [0:STAGES];
    reg [63:0] addb_pipe [0:STAGES];
    // Pipeline registers for carry signals between stages
    reg [STAGES:0] carry_pipe;
    // Pipeline registers for sums per stage
    reg [STAGE_BITS-1:0] sum_pipe [0:STAGES-1];
    // Pipeline registers for enable signal
    reg [STAGES:0] en_pipe;

    integer i;

    // Initial registers for operands and enable
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (i = 0; i <= STAGES; i = i + 1) begin
                adda_pipe[i] <= 64'd0;
                addb_pipe[i] <= 64'd0;
                en_pipe[i] <= 1'b0;
            end
            carry_pipe <= 0;
            for (i = 0; i < STAGES; i = i + 1) begin
                sum_pipe[i] <= 0;
            end
            result <= 0;
            o_en <= 0;
        end else begin
            // Shift operands and enable through pipeline registers
            adda_pipe[0] <= adda;
            addb_pipe[0] <= addb;
            en_pipe[0] <= i_en;

            for (i = 1; i <= STAGES; i = i + 1) begin
                adda_pipe[i] <= adda_pipe[i-1];
                addb_pipe[i] <= addb_pipe[i-1];
                en_pipe[i] <= en_pipe[i-1];
            end

            // Ripple carry initialization: carry-in to first stage is zero
            carry_pipe[0] <= 1'b0;

            // Compute each pipeline stage
            // Each stage adds 8 bits with carry_in and outputs carry_out
            for (i = 0; i < STAGES; i = i + 1) begin
                // Extract 8 bits for this stage from pipeline registers at stage i
                wire [7:0] a_part = adda_pipe[i][(i*STAGE_BITS) +: STAGE_BITS];
                wire [7:0] b_part = addb_pipe[i][(i*STAGE_BITS) +: STAGE_BITS];
                wire carry_in = carry_pipe[i];

                // Sum and carry calculation for this stage
                reg [8:0] stage_sum;
                stage_sum = a_part + b_part + carry_in;

                // Register sum and carry out at next clock edge
                sum_pipe[i] <= stage_sum[7:0];
                carry_pipe[i+1] <= stage_sum[8];
            end

            // After last stage sums and carries are registered, assemble final result and output enable
            if (en_pipe[STAGES]) begin
                // Concatenate sums from all stages and carry out
                // sum_pipe[] holds 8-bit sums per stage; we combine in order
                reg [64:0] final_sum;
                final_sum = {carry_pipe[STAGES], 
                             sum_pipe[STAGES-1], sum_pipe[STAGES-2], sum_pipe[STAGES-3], sum_pipe[STAGES-4],
                             sum_pipe[STAGES-5], sum_pipe[STAGES-6], sum_pipe[STAGES-7], sum_pipe[STAGES-8]};
                // sum_pipe indices: 0 to 7, so sum_pipe[7] is MSB stage, sum_pipe[0] is LSB stage
                // We need to concatenate from MSB stage to LSB stage in correct order:
                // final_sum[64] = carry_pipe[8]
                // final_sum[63:56] = sum_pipe[7]
                // final_sum[55:48] = sum_pipe[6]
                // ...
                // final_sum[7:0] = sum_pipe[0]
                // So build by concatenation in reverse order:
                final_sum = {carry_pipe[STAGES],
                             sum_pipe[7], sum_pipe[6], sum_pipe[5], sum_pipe[4],
                             sum_pipe[3], sum_pipe[2], sum_pipe[1], sum_pipe[0]};
                result <= final_sum;
                o_en <= 1'b1;
            end else begin
                o_en <= 1'b0;
            end
        end
    end

endmodule