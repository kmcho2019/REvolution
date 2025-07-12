module adder_pipe_64bit #(
    parameter DATA_WIDTH = 64,
    parameter STG_WIDTH  = 8,
    parameter NUM_STAGES = DATA_WIDTH / STG_WIDTH
)(
    input                     clk,
    input                     rst_n,
    input                     i_en,
    input      [DATA_WIDTH-1:0] adda,
    input      [DATA_WIDTH-1:0] addb,
    output reg [DATA_WIDTH:0] result,
    output reg                o_en
);

    // Local variables for pipeline registers
    reg [STG_WIDTH-1:0] sum_pipe [0:NUM_STAGES-1];
    reg                carry_pipe [0:NUM_STAGES];
    reg                en_pipe [0:NUM_STAGES];

    integer i;

    // Initialize carry_in to zero
    wire carry_in_0 = 1'b0;

    // Wires to hold the addition result per stage
    wire [STG_WIDTH:0] stage_sum [0:NUM_STAGES-1];

    // Assign input slices and add with carry from previous stage
    // We compute stage_sum combinationally based on pipeline registers for carry
    // The carry for stage 0 is 0 or carry_pipe[0] is initialized/reset to 0

    // For adding with carry from previous stage, we use carry_pipe[i] as carry-in for stage i

    // Pipeline registers update logic in sequential always block below

    // Compute stage sums combinationally using the registered carry from previous stage
    // carry_pipe[0] corresponds to carry_in_0 (reset to 0)
    // At each clock cycle, carry_pipe[i] is updated with carry from stage i-1 addition
    // To avoid combinational loop, stage_sum depends on carry_pipe[i], which updates from previous clock

    // To implement ripple carry addition, the carry used by stage i must come from stage i-1 result,
    // So we compute stage_sum[i] using carry_pipe[i]

    // To have carry_pipe[0] = 0, we will register it at reset.

    // Calculate stage sums combinationally:
    generate
        genvar idx;
        for (idx = 0; idx < NUM_STAGES; idx = idx +1) begin : ADD_STAGE
            assign stage_sum[idx] = {1'b0, adda[STG_WIDTH*(idx+1)-1 : STG_WIDTH*idx]} 
                                  + {1'b0, addb[STG_WIDTH*(idx+1)-1 : STG_WIDTH*idx]}
                                  + carry_pipe[idx];
        end
    endgenerate

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (i = 0; i < NUM_STAGES; i = i + 1) begin
                sum_pipe[i] <= 0;
                carry_pipe[i] <= 0;
                en_pipe[i] <= 0;
            end
            carry_pipe[NUM_STAGES] <= 0;
            en_pipe[NUM_STAGES] <= 0;
            result <= 0;
            o_en <= 0;
        end else begin
            // Stage 0 carry_in is fixed to zero at every cycle (carry_pipe[0])
            carry_pipe[0] <= 1'b0;

            for (i = 0; i < NUM_STAGES; i = i + 1) begin
                // Register sum and carry-out of current stage
                sum_pipe[i] <= stage_sum[i][STG_WIDTH-1:0];
                carry_pipe[i+1] <= stage_sum[i][STG_WIDTH];
            end

            // Pipeline the enable signal along the stages
            en_pipe[0] <= i_en;
            for (i = 1; i <= NUM_STAGES; i = i + 1) begin
                en_pipe[i] <= en_pipe[i-1];
            end

            // When final stage is valid, assemble the full result
            if (en_pipe[NUM_STAGES]) begin
                // Concatenate sums from all stages and final carry
                result <= {carry_pipe[NUM_STAGES],
                           sum_pipe[NUM_STAGES-1], sum_pipe[NUM_STAGES-2],
                           sum_pipe[NUM_STAGES-3], sum_pipe[NUM_STAGES-4],
                           sum_pipe[NUM_STAGES-5], sum_pipe[NUM_STAGES-6],
                           sum_pipe[NUM_STAGES-7], sum_pipe[NUM_STAGES-8]};
                o_en <= 1'b1;
            end else begin
                result <= 0;
                o_en <= 1'b0;
            end
        end
    end

endmodule