module adder_pipe_64bit #(
    parameter DATA_WIDTH = 64,
    parameter STG_WIDTH  = 8
)(
    input                        clk,
    input                        rst_n,
    input                        i_en,
    input      [DATA_WIDTH-1:0]  adda,
    input      [DATA_WIDTH-1:0]  addb,
    output reg [DATA_WIDTH:0]    result,
    output reg                   o_en
);

    localparam NUM_STAGES = DATA_WIDTH / STG_WIDTH;

    integer i;

    // Pipeline registers for operand slices
    reg [STG_WIDTH-1:0] adda_slices [0:NUM_STAGES-1];
    reg [STG_WIDTH-1:0] addb_slices [0:NUM_STAGES-1];

    // Pipeline registers for sum slices (stage results)
    reg [STG_WIDTH-1:0] sum_pipe [0:NUM_STAGES-1];

    // Pipeline registers for carry between stages: carry_pipe[0] is carry-in of stage 0
    reg carry_pipe [0:NUM_STAGES];

    // Pipeline register for enable signal per stage
    reg en_pipe [0:NUM_STAGES];

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset all pipeline registers
            for (i = 0; i < NUM_STAGES; i = i + 1) begin
                adda_slices[i] <= {STG_WIDTH{1'b0}};
                addb_slices[i] <= {STG_WIDTH{1'b0}};
                sum_pipe[i] <= {STG_WIDTH{1'b0}};
                en_pipe[i] <= 1'b0;
                carry_pipe[i] <= 1'b0;
            end
            carry_pipe[NUM_STAGES] <= 1'b0;
            en_pipe[NUM_STAGES] <= 1'b0;
            result <= {(DATA_WIDTH+1){1'b0}};
            o_en <= 1'b0;
        end else begin
            // Shift enable signal down the pipeline
            en_pipe[0] <= i_en;
            for (i = 1; i <= NUM_STAGES; i = i + 1) begin
                en_pipe[i] <= en_pipe[i-1];
            end

            // Load or shift operand slices
            // At stage 0: load when i_en high, else keep zero (or previous)
            if (i_en) begin
                for (i = 0; i < NUM_STAGES; i = i + 1) begin
                    adda_slices[i] <= adda[i*STG_WIDTH +: STG_WIDTH];
                    addb_slices[i] <= addb[i*STG_WIDTH +: STG_WIDTH];
                end
            end else begin
                for (i = 0; i < NUM_STAGES; i = i + 1) begin
                    adda_slices[i] <= adda_slices[i];
                    addb_slices[i] <= addb_slices[i];
                end
            end

            // Shift operand slices down the pipeline
            // To pipeline properly, shift slices at stages > 0 on every clock cycle
            for (i = NUM_STAGES-1; i > 0; i = i - 1) begin
                if (!i_en) begin
                    // When not loading new operands, shift slices down stages
                    adda_slices[i] <= adda_slices[i-1];
                    addb_slices[i] <= addb_slices[i-1];
                end
            end
            // Stage 0 operands already assigned above (loaded or held)

            // Initialize carry-in of stage 0 to zero every cycle
            carry_pipe[0] <= 1'b0;

            // Perform addition stage by stage
            for (i = 0; i < NUM_STAGES; i = i + 1) begin
                if (en_pipe[i]) begin
                    {carry_pipe[i+1], sum_pipe[i]} <= adda_slices[i] + addb_slices[i] + carry_pipe[i];
                end else begin
                    // Hold previous values when not enabled
                    sum_pipe[i] <= sum_pipe[i];
                    carry_pipe[i+1] <= carry_pipe[i+1];
                end
            end

            // Assemble final result from pipeline sums and last carry_out when output is ready
            if (en_pipe[NUM_STAGES]) begin
                // Concatenate sums from highest stage to lowest, plus final carry
                // sum_pipe[NUM_STAGES-1] is MSB slice, sum_pipe[0] is LSB slice
                result <= {carry_pipe[NUM_STAGES]};
                for (i = NUM_STAGES-1; i >= 0; i = i - 1) begin
                    result <= (result << STG_WIDTH) | sum_pipe[i];
                end
            end else begin
                result <= result;
            end

            // Output enable reflects when result is valid
            o_en <= en_pipe[NUM_STAGES];
        end
    end

endmodule