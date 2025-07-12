module adder_pipe_64bit(
    input               clk,
    input               rst_n,
    input               i_en,
    input       [63:0]  adda,
    input       [63:0]  addb,
    output reg  [64:0]  result,
    output reg          o_en
);

    localparam STG_WIDTH = 16;
    localparam NUM_STAGES = 64 / STG_WIDTH; // 4 stages

    // Pipeline registers for operands
    reg [STG_WIDTH-1:0] a_reg [0:NUM_STAGES-1];
    reg [STG_WIDTH-1:0] b_reg [0:NUM_STAGES-1];

    // Pipeline registers for carries and sums
    reg carry_reg [0:NUM_STAGES];
    reg [STG_WIDTH-1:0] sum_reg [0:NUM_STAGES-1];

    // Pipeline registers for enable signal
    reg [NUM_STAGES:0] en_pipeline;

    integer i;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset all pipeline registers and outputs
            for (i = 0; i < NUM_STAGES; i = i + 1) begin
                a_reg[i]   <= 0;
                b_reg[i]   <= 0;
                sum_reg[i] <= 0;
                carry_reg[i] <= 0;
            end
            carry_reg[NUM_STAGES] <= 0;
            en_pipeline <= 0;
            result <= 0;
            o_en <= 0;
        end else begin
            // Shift enable pipeline
            en_pipeline <= {en_pipeline[NUM_STAGES-1:0], i_en};

            // Stage 0 input registers and carry_in=0
            if (i_en) begin
                a_reg[0] <= adda[STG_WIDTH-1:0];
                b_reg[0] <= addb[STG_WIDTH-1:0];
                carry_reg[0] <= 1'b0;
            end else if (en_pipeline[0]) begin
                // hold previous operands and carry to allow sum calculation below
                a_reg[0] <= a_reg[0];
                b_reg[0] <= b_reg[0];
                carry_reg[0] <= carry_reg[0];
            end

            // Compute sum and carry for stage 0
            {carry_reg[1], sum_reg[0]} <= a_reg[0] + b_reg[0] + carry_reg[0];

            // Subsequent stages
            for (i = 1; i < NUM_STAGES; i = i + 1) begin
                if (en_pipeline[i]) begin
                    a_reg[i] <= adda[STG_WIDTH*i +: STG_WIDTH];
                    b_reg[i] <= addb[STG_WIDTH*i +: STG_WIDTH];
                    carry_reg[i] <= carry_reg[i];
                end else begin
                    a_reg[i] <= a_reg[i];
                    b_reg[i] <= b_reg[i];
                    carry_reg[i] <= carry_reg[i];
                end
                // sum and carry calculation for stage i
                {carry_reg[i+1], sum_reg[i]} <= a_reg[i] + b_reg[i] + carry_reg[i];
            end

            // When the last enable pipeline stage is asserted, output result
            if (en_pipeline[NUM_STAGES]) begin
                result <= {carry_reg[NUM_STAGES], sum_reg[NUM_STAGES-1], sum_reg[NUM_STAGES-2], sum_reg[NUM_STAGES-3], sum_reg[0]};
                // Correct concatenation order from MSB to LSB:
                // sum_reg[3] is bits 63:48, sum_reg[2] 47:32, sum_reg[1] 31:16, sum_reg[0] 15:0
                // Actually sum_reg indexes 0..3, so rewrite with explicit order:
                result <= {carry_reg[NUM_STAGES], 
                           sum_reg[3],
                           sum_reg[2],
                           sum_reg[1],
                           sum_reg[0]};
            end

            // Output enable update
            o_en <= en_pipeline[NUM_STAGES];
        end
    end

endmodule