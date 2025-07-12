module adder_pipe_64bit (
    input               clk,
    input               rst_n,
    input               i_en,
    input      [63:0]   adda,
    input      [63:0]   addb,
    output reg [64:0]   result,
    output reg          o_en
);

    localparam STAGE_BITS = 16;
    localparam NUM_STAGES = 4;

    // Pipeline registers for operands (16 bits each)
    reg [STAGE_BITS-1:0] adda_stage  [0:NUM_STAGES-1];
    reg [STAGE_BITS-1:0] addb_stage  [0:NUM_STAGES-1];

    // Pipeline registers for partial sums
    reg [STAGE_BITS-1:0] sum_stage   [0:NUM_STAGES-1];

    // Carry signals between stages, carry_in for stage 0 is zero
    reg carry_stage [0:NUM_STAGES];

    // Pipeline register for output enable
    reg valid_stage [0:NUM_STAGES];

    integer i;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset pipeline
            for (i = 0; i < NUM_STAGES; i = i + 1) begin
                adda_stage[i] <= {STAGE_BITS{1'b0}};
                addb_stage[i] <= {STAGE_BITS{1'b0}};
                sum_stage[i]  <= {STAGE_BITS{1'b0}};
                carry_stage[i] <= 1'b0;
                valid_stage[i] <= 1'b0;
            end
            carry_stage[NUM_STAGES] <= 1'b0;
            valid_stage[NUM_STAGES] <= 1'b0;
            result <= 65'b0;
            o_en <= 1'b0;
        end else begin
            // Load stage 0 operands and valid signal if i_en asserted
            if (i_en) begin
                adda_stage[0] <= adda[15:0];
                addb_stage[0] <= addb[15:0];
            end
            valid_stage[0] <= i_en;
            carry_stage[0] <= 1'b0;  // initial carry in

            // For stages 1 to NUM_STAGES-1, propagate operands from input and valid signal from previous stage
            // But the operands come from the original input (adda, addb) sliced per stage, synchronously
            // to align with valid_stage shifting.
            if (valid_stage[0]) begin
                adda_stage[1] <= adda[31:16];
                addb_stage[1] <= addb[31:16];
            end
            valid_stage[1] <= valid_stage[0];

            if (valid_stage[1]) begin
                adda_stage[2] <= adda[47:32];
                addb_stage[2] <= addb[47:32];
            end
            valid_stage[2] <= valid_stage[1];

            if (valid_stage[2]) begin
                adda_stage[3] <= adda[63:48];
                addb_stage[3] <= addb[63:48];
            end
            valid_stage[3] <= valid_stage[2];

            // Compute sums and carries for all stages, carry_stage[i] is carry_in
            for (i = 0; i < NUM_STAGES; i = i + 1) begin
                {carry_stage[i+1], sum_stage[i]} <= adda_stage[i] + addb_stage[i] + carry_stage[i];
            end

            valid_stage[NUM_STAGES] <= valid_stage[NUM_STAGES-1];

            // Assemble final result when output valid is asserted
            if (valid_stage[NUM_STAGES]) begin
                result <= {carry_stage[NUM_STAGES],
                           sum_stage[3],
                           sum_stage[2],
                           sum_stage[1],
                           sum_stage[0]};
            end

            o_en <= valid_stage[NUM_STAGES];
        end
    end

endmodule