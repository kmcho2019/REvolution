module adder_pipe_64bit (
    input               clk,
    input               rst_n,
    input               i_en,
    input       [63:0]  adda,
    input       [63:0]  addb,
    output reg  [64:0]  result,
    output reg          o_en
);

    localparam STAGE_BITS = 8;
    localparam NUM_STAGES = 8;

    // Pipeline registers for sums
    reg [STAGE_BITS-1:0] sum_pipe [0:NUM_STAGES-1];
    // Pipeline registers for carry (one bit per stage plus input carry)
    reg carry_pipe [0:NUM_STAGES];
    // Pipeline registers for enable signal
    reg en_pipe [0:NUM_STAGES];

    integer i;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset pipeline registers
            for (i = 0; i <= NUM_STAGES; i = i + 1) begin
                carry_pipe[i] <= 1'b0;
                en_pipe[i] <= 1'b0;
            end
            for (i = 0; i < NUM_STAGES; i = i + 1) begin
                sum_pipe[i] <= {STAGE_BITS{1'b0}};
            end
            result <= {(64+1){1'b0}};
            o_en <= 1'b0;
        end else begin
            // Stage 0 input carry is zero
            carry_pipe[0] <= 1'b0;
            en_pipe[0] <= i_en;

            // For each pipeline stage
            for (i = 0; i < NUM_STAGES; i = i + 1) begin
                // Calculate sum and carry-out for this 8-bit stage
                {carry_pipe[i+1], sum_pipe[i]} <= adda[STAGE_BITS*i +: STAGE_BITS] 
                                                + addb[STAGE_BITS*i +: STAGE_BITS] 
                                                + carry_pipe[i];
                // Propagate enable signal
                en_pipe[i+1] <= en_pipe[i];
            end

            // Concatenate sums and final carry-out into result
            result <= {carry_pipe[NUM_STAGES], 
                       sum_pipe[NUM_STAGES-1], sum_pipe[NUM_STAGES-2], sum_pipe[NUM_STAGES-3], sum_pipe[NUM_STAGES-4],
                       sum_pipe[NUM_STAGES-5], sum_pipe[NUM_STAGES-6], sum_pipe[NUM_STAGES-7], sum_pipe[NUM_STAGES-8]};
            // Output enable signal after pipeline delay
            o_en <= en_pipe[NUM_STAGES];
        end
    end

endmodule