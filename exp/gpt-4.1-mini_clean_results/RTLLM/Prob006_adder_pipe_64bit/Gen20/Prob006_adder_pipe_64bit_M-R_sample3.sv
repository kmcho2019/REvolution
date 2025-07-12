module adder_pipe_64bit(
    input              clk,
    input              rst_n,
    input              i_en,
    input      [63:0]  adda,
    input      [63:0]  addb,
    output reg [64:0]  result,
    output reg         o_en
);

    // Parameters for pipelining stages and data widths
    localparam STAGE_WIDTH = 16;
    localparam NUM_STAGES = 64 / STAGE_WIDTH;

    // Stage-wise pipeline registers for operands, enable, partial sums and carries
    reg [63:0] stage_adda    [0:NUM_STAGES];
    reg [63:0] stage_addb    [0:NUM_STAGES];
    reg        stage_en      [0:NUM_STAGES];
    reg        stage_carry   [0:NUM_STAGES];     // carry-in per stage

    // Partial sums per stage - combinational
    wire [STAGE_WIDTH:0] stage_sum  [0:NUM_STAGES-1]; // 16-bit sum + carry out per stage

    integer i;

    // At each stage, compute sum and carry-out for corresponding 16-bit slice
    genvar s;
    generate
        for (s = 0; s < NUM_STAGES; s = s + 1) begin : stage_adder
            wire [STAGE_WIDTH-1:0] a_slice = stage_adda[s][s*STAGE_WIDTH +: STAGE_WIDTH];
            wire [STAGE_WIDTH-1:0] b_slice = stage_addb[s][s*STAGE_WIDTH +: STAGE_WIDTH];
            assign stage_sum[s] = a_slice + b_slice + stage_carry[s];
        end
    endgenerate

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset all pipeline registers
            for (i = 0; i <= NUM_STAGES; i = i + 1) begin
                stage_adda[i] <= 64'd0;
                stage_addb[i] <= 64'd0;
                stage_en[i] <= 1'b0;
                stage_carry[i] <= 1'b0;
            end
            result <= 65'd0;
            o_en <= 1'b0;
        end else begin
            // Load inputs into stage 0 pipeline registers
            stage_adda[0] <= adda;
            stage_addb[0] <= addb;
            stage_en[0] <= i_en;
            stage_carry[0] <= 1'b0;  // initial carry-in zero

            // Propagate pipeline for stages 0 to NUM_STAGES-1:
            // Capture sum bits and propagate carry to next stage
            // Advance operand and enable registers for next stage

            for (i = 0; i < NUM_STAGES; i = i + 1) begin
                // Update carry-in for next stage from current stage sum carry-out
                stage_carry[i + 1] <= stage_sum[i][STAGE_WIDTH];

                // Pass operands and enable from previous stage to current stage
                if (i != 0) begin
                    stage_adda[i] <= stage_adda[i - 1];
                    stage_addb[i] <= stage_addb[i - 1];
                    stage_en[i]   <= stage_en[i - 1];
                end

                // For the final pipeline stage, also pass registers to stage NUM_STAGES
                // This ensures stage_adda[NUM_STAGES], stage_addb[NUM_STAGES], stage_en[NUM_STAGES] 
                // hold the final pipeline data for output synchronization
            end

            // Advance stage NUM_STAGES pipeline registers (copy from previous stage)
            stage_adda[NUM_STAGES] <= stage_adda[NUM_STAGES - 1];
            stage_addb[NUM_STAGES] <= stage_addb[NUM_STAGES - 1];
            stage_en[NUM_STAGES]   <= stage_en[NUM_STAGES - 1];
            stage_carry[NUM_STAGES] <= stage_carry[NUM_STAGES]; // remains stable (carry from last addition)

            // Assemble the final sum from partial sums:
            // Concatenate partial sums (16-bit) from stages 0 to NUM_STAGES-1

            // Since partial sums are not registered, latch partial sums into temporary regs before assignment:
            // Use temporary registers to hold stage_sum slices
            // To avoid combinational loops, reconstruct sum on clock edge by gathering stage_sum slices

            // Declare temporary reg for concatenation
            reg [63:0] sum_concat;
            // Manually concatenate 16-bit partial sums from stage_sum wires
            sum_concat[ 15:  0] = stage_sum[0][15:0];
            sum_concat[ 31: 16] = stage_sum[1][15:0];
            sum_concat[ 47: 32] = stage_sum[2][15:0];
            sum_concat[ 63: 48] = stage_sum[3][15:0];

            // Output result concatenates carry-out of last stage with sum_concat
            result <= {stage_sum[NUM_STAGES-1][STAGE_WIDTH], sum_concat};
            o_en <= stage_en[NUM_STAGES];
        end
    end

endmodule