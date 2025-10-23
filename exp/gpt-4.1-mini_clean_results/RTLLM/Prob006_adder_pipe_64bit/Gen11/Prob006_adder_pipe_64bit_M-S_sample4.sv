module adder_pipe_64bit (
    input              clk,
    input              rst_n,
    input              i_en,
    input      [63:0]  adda,
    input      [63:0]  addb,
    output reg [64:0]  result,
    output reg         o_en
);

    // Parameters for pipeline stages
    localparam STAGE_BITS = 16;
    localparam NUM_STAGES = 4;

    // Pipeline registers for operands and carry
    reg [STAGE_BITS-1:0] a_reg [0:NUM_STAGES-1];
    reg [STAGE_BITS-1:0] b_reg [0:NUM_STAGES-1];
    reg                  carry_in_reg [0:NUM_STAGES-1];
    reg                  en_reg [0:NUM_STAGES]; // enable signal pipeline

    // Registers to hold sum per stage
    reg [STAGE_BITS-1:0] sum_reg [0:NUM_STAGES-1];
    reg                  carry_out_reg [0:NUM_STAGES-1];

    integer i;

    // Pipeline logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset all pipeline registers
            for (i = 0; i < NUM_STAGES; i = i + 1) begin
                a_reg[i]        <= {STAGE_BITS{1'b0}};
                b_reg[i]        <= {STAGE_BITS{1'b0}};
                carry_in_reg[i] <= 1'b0;
                sum_reg[i]      <= {STAGE_BITS{1'b0}};
                carry_out_reg[i]<= 1'b0;
                en_reg[i]       <= 1'b0;
            end
            en_reg[NUM_STAGES] <= 1'b0;
            result            <= 65'b0;
            o_en              <= 1'b0;
        end else begin
            // Shift enable pipeline and load input enable
            en_reg[0] <= i_en;
            for (i = 1; i <= NUM_STAGES; i = i + 1) begin
                en_reg[i] <= en_reg[i-1];
            end

            // Stage 0 inputs and carry_in=0
            if (i_en) begin
                a_reg[0]        <= adda[15:0];
                b_reg[0]        <= addb[15:0];
                carry_in_reg[0] <= 1'b0;
            end

            // Compute sum and carry_out stage 0
            {carry_out_reg[0], sum_reg[0]} <= a_reg[0] + b_reg[0] + carry_in_reg[0];

            // For stages 1 to NUM_STAGES-1, register inputs from previous stage
            for (i = 1; i < NUM_STAGES; i = i + 1) begin
                if (en_reg[i]) begin
                    a_reg[i]        <= adda[(i*STAGE_BITS) +: STAGE_BITS];
                    b_reg[i]        <= addb[(i*STAGE_BITS) +: STAGE_BITS];
                    carry_in_reg[i] <= carry_out_reg[i-1];
                end

                // Compute sums and carry outs for stages > 0
                {carry_out_reg[i], sum_reg[i]} <= a_reg[i] + b_reg[i] + carry_in_reg[i];
            end

            // Output assembly at last pipeline stage
            if (en_reg[NUM_STAGES]) begin
                result <= {
                    carry_out_reg[NUM_STAGES-1],  // MSB carry out
                    sum_reg[NUM_STAGES-1],
                    sum_reg[NUM_STAGES-2],
                    sum_reg[NUM_STAGES-3],
                    sum_reg[0]
                };
            end

            o_en <= en_reg[NUM_STAGES];
        end
    end

endmodule