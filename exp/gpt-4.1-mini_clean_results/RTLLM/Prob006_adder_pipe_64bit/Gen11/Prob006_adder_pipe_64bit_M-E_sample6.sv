module adder_pipe_64bit (
    input               clk,
    input               rst_n,
    input               i_en,
    input      [63:0]   adda,
    input      [63:0]   addb,
    output reg [64:0]   result,
    output reg          o_en
);

    localparam STAGE_BITS = 8;
    localparam NUM_STAGES = 64 / STAGE_BITS;

    // Registers for pipeline: operands slices for each stage
    reg [STAGE_BITS-1:0] stage_adda   [0:NUM_STAGES-1];
    reg [STAGE_BITS-1:0] stage_addb   [0:NUM_STAGES-1];

    // Carry registers between stages: carry_in for each stage
    reg carry_in_reg [0:NUM_STAGES];

    // Sum outputs of each stage
    reg [STAGE_BITS-1:0] sum_reg [0:NUM_STAGES-1];

    // Enable pipeline registers: to track valid data through pipeline
    reg en_pipe [0:NUM_STAGES];

    integer i;

    // Combinational wires for sum and carry out per stage
    wire [STAGE_BITS:0] sum_w [0:NUM_STAGES-1]; // one extra bit for carry out

    // Assign carry_in zero at pipeline input stage
    // carry_in_reg[0] is input carry (zero)
    // Each stage adds carry_in_reg[i], stage_adda[i], and stage_addb[i]
    genvar gi;
    generate
        for (gi = 0; gi < NUM_STAGES; gi = gi + 1) begin : gen_stages
            assign sum_w[gi] = carry_in_reg[gi] + stage_adda[gi] + stage_addb[gi];
        end
    endgenerate

    // Pipeline process: on clock, register slices, carries, sums, and enable
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Clear all pipeline registers
            for (i = 0; i < NUM_STAGES; i = i + 1) begin
                stage_adda[i]   <= 0;
                stage_addb[i]   <= 0;
                sum_reg[i]      <= 0;
                en_pipe[i]      <= 0;
                carry_in_reg[i] <= 0;
            end
            // Also clear carry_in_reg for last stage
            carry_in_reg[NUM_STAGES] <= 0;

            result <= 0;
            o_en <= 0;
        end else begin
            // Pipeline enable shift register
            en_pipe[0] <= i_en;
            for (i = 1; i <= NUM_STAGES; i = i + 1) begin
                en_pipe[i] <= en_pipe[i-1];
            end

            // Stage 0 inputs registration
            stage_adda[0] <= adda[STAGE_BITS*0 +: STAGE_BITS];
            stage_addb[0] <= addb[STAGE_BITS*0 +: STAGE_BITS];
            carry_in_reg[0] <= 1'b0; // input carry is zero

            // For stages >= 1, shift inputs forward through pipeline registers
            for (i = 1; i < NUM_STAGES; i = i + 1) begin
                stage_adda[i] <= stage_adda[i-1];
                stage_addb[i] <= stage_addb[i-1];
                carry_in_reg[i] <= carry_in_reg[i-1];
            end

            // Compute and register sums and carry_out for each stage (except stage 0 sum_reg to stage NUM_STAGES-1)
            // carry_out of stage i is MSB of sum_w[i]
            for (i = 0; i < NUM_STAGES; i = i + 1) begin
                sum_reg[i] <= sum_w[i][STAGE_BITS-1:0];
                carry_in_reg[i+1] <= sum_w[i][STAGE_BITS];
            end

            // After all stages update, assemble result and o_en at output stage
            if (en_pipe[NUM_STAGES]) begin
                // Concatenate sum_reg slices from stage 0 to last stage
                // plus final carry_in_reg[NUM_STAGES]
                result <= {
                    carry_in_reg[NUM_STAGES],   // MSB carry out
                    sum_reg[NUM_STAGES-1],
                    sum_reg[NUM_STAGES-2],
                    sum_reg[NUM_STAGES-3],
                    sum_reg[NUM_STAGES-4],
                    sum_reg[NUM_STAGES-5],
                    sum_reg[NUM_STAGES-6],
                    sum_reg[NUM_STAGES-7],
                    sum_reg[NUM_STAGES-8]
                };
            end else begin
                result <= 0;
            end

            // Output enable aligned to pipeline latency
            o_en <= en_pipe[NUM_STAGES];
        end
    end

endmodule