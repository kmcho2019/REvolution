module adder_pipe_64bit (
    input              clk,
    input              rst_n,
    input              i_en,
    input      [63:0]  adda,
    input      [63:0]  addb,
    output reg [64:0]  result,
    output reg         o_en
);

    localparam STAGES = 8;
    localparam WIDTH_PER_STAGE = 8;

    // Operand pipeline registers per stage
    reg [WIDTH_PER_STAGE-1:0] adda_pipe [0:STAGES-1];
    reg [WIDTH_PER_STAGE-1:0] addb_pipe [0:STAGES-1];

    // Sum pipeline registers per stage
    reg [WIDTH_PER_STAGE-1:0] sum_pipe [0:STAGES-1];

    // Carry pipeline: carry_pipe[i] is the carry into stage i
    reg carry_pipe [0:STAGES];

    // Enable pipeline for data valid tracking
    reg en_pipe [0:STAGES];

    integer i;

    // Combinational wires for sum + carry out at each stage
    wire [WIDTH_PER_STAGE:0] sum_carry [0:STAGES-1];

    generate
        genvar idx;
        for (idx = 0; idx < STAGES; idx = idx + 1) begin : gen_sum_carry
            assign sum_carry[idx] = adda_pipe[idx] + addb_pipe[idx] + carry_pipe[idx];
        end
    endgenerate

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset all pipeline registers
            for (i = 0; i < STAGES; i = i + 1) begin
                adda_pipe[i] <= {WIDTH_PER_STAGE{1'b0}};
                addb_pipe[i] <= {WIDTH_PER_STAGE{1'b0}};
                sum_pipe[i]  <= {WIDTH_PER_STAGE{1'b0}};
                carry_pipe[i] <= 1'b0;
                en_pipe[i] <= 1'b0;
            end
            carry_pipe[STAGES] <= 1'b0;
            en_pipe[STAGES] <= 1'b0;
            result <= 65'b0;
            o_en <= 1'b0;
        end else begin
            // Shift operand slices pipeline:
            // On i_en assert: load stage 0 slices from inputs; else shift pipeline registers forward
            if (i_en) begin
                // Load operand slices into stage 0
                adda_pipe[0] <= adda[7:0];
                addb_pipe[0] <= addb[7:0];
                // shift remaining stages forward
                for (i = 1; i < STAGES; i = i + 1) begin
                    adda_pipe[i] <= adda_pipe[i-1];
                    addb_pipe[i] <= addb_pipe[i-1];
                end

                en_pipe[0] <= 1'b1;      // new valid data in stage 0
                carry_pipe[0] <= 1'b0;   // initial carry in zero for new addition

                // Shift enable and carry for subsequent stages
                for (i = 1; i <= STAGES; i = i + 1) begin
                    en_pipe[i] <= en_pipe[i-1];
                    carry_pipe[i] <= carry_pipe[i-1];
                end
            end else begin
                // No new input, just shift pipeline registers forward holding operand slices and enable signals
                for (i = STAGES-1; i > 0; i = i - 1) begin
                    adda_pipe[i] <= adda_pipe[i-1];
                    addb_pipe[i] <= addb_pipe[i-1];
                end
                // Keep stage 0 operands stable if no new input
                adda_pipe[0] <= adda_pipe[0];
                addb_pipe[0] <= addb_pipe[0];

                // Shift enable and carry pipeline registers
                for (i = STAGES; i > 0; i = i - 1) begin
                    en_pipe[i] <= en_pipe[i-1];
                    carry_pipe[i] <= carry_pipe[i-1];
                end
                en_pipe[0] <= 1'b0;
                carry_pipe[0] <= carry_pipe[0]; // hold stable carry_in at stage 0 when idle
            end

            // Calculate sums and carry_out per stage, store in pipeline registers
            for (i = 0; i < STAGES; i = i + 1) begin
                sum_pipe[i] <= sum_carry[i][WIDTH_PER_STAGE-1:0];
                carry_pipe[i+1] <= sum_carry[i][WIDTH_PER_STAGE];
            end

            // Output result and enable valid when final pipeline stage is valid
            o_en <= en_pipe[STAGES];
            if (en_pipe[STAGES]) begin
                // Concatenate all sum slices from LSB (stage 0) to MSB (stage 7) and final carry_out
                result <= {
                    carry_pipe[STAGES],
                    sum_pipe[STAGES-1],
                    sum_pipe[STAGES-2],
                    sum_pipe[STAGES-3],
                    sum_pipe[STAGES-4],
                    sum_pipe[STAGES-5],
                    sum_pipe[STAGES-6],
                    sum_pipe[STAGES-7],
                    sum_pipe[0]
                };
            end else begin
                // Hold previous value if no valid output
                result <= result;
            end
        end
    end

endmodule