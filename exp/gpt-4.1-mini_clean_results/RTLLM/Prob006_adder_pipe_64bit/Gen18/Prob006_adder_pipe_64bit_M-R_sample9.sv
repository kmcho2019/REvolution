module adder_pipe_64bit #(
    parameter DATA_WIDTH = 64,
    parameter STG_WIDTH  = 8
)(
    input                       clk,
    input                       rst_n,
    input                       i_en,
    input      [DATA_WIDTH-1:0] adda,
    input      [DATA_WIDTH-1:0] addb,
    output reg [DATA_WIDTH:0]   result,
    output reg                  o_en
);

    localparam NUM_STAGES = DATA_WIDTH / STG_WIDTH;

    integer i;

    // Pipeline registers for operand slices per stage
    reg [STG_WIDTH-1:0] adda_slices [0:NUM_STAGES-1];
    reg [STG_WIDTH-1:0] addb_slices [0:NUM_STAGES-1];

    // Pipeline registers for sum per stage
    reg [STG_WIDTH-1:0] sum_pipe [0:NUM_STAGES-1];

    // Pipeline registers for carry between stages (carry_pipe[0] is carry-in to stage 0)
    reg carry_pipe [0:NUM_STAGES];

    // Pipeline registers for enable signal per stage
    reg en_pipe [0:NUM_STAGES];

    // On reset, initialize all pipeline registers to zero
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
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
            // Shift enable pipeline, loading new input enable at stage 0
            en_pipe[0] <= i_en;
            for (i = 1; i <= NUM_STAGES; i = i + 1)
                en_pipe[i] <= en_pipe[i-1];

            // Shift operand slices pipeline
            // At stage 0, load slices from inputs if i_en is high; else zero
            if (i_en) begin
                for (i = 0; i < NUM_STAGES; i = i + 1) begin
                    adda_slices[0] <= adda[STG_WIDTH*i +: STG_WIDTH];
                    addb_slices[0] <= addb[STG_WIDTH*i +: STG_WIDTH];
                end
            end else begin
                adda_slices[0] <= {STG_WIDTH{1'b0}};
                addb_slices[0] <= {STG_WIDTH{1'b0}};
            end

            // Shift operands down the pipeline for stages 1..NUM_STAGES-1
            for (i = NUM_STAGES-1; i > 0; i = i - 1) begin
                adda_slices[i] <= adda_slices[i-1];
                addb_slices[i] <= addb_slices[i-1];
            end

            // Carry pipeline: carry_pipe[0] is carry-in to stage 0
            // Set carry_in at stage 0 to zero if new input enabled
            carry_pipe[0] <= i_en ? 1'b0 : carry_pipe[0];

            // Propagate carry and compute sums for each stage when enabled
            for (i = 0; i < NUM_STAGES; i = i + 1) begin
                if (en_pipe[i]) begin
                    {carry_pipe[i+1], sum_pipe[i]} <= adda_slices[i] + addb_slices[i] + carry_pipe[i];
                end else begin
                    // If not enabled, hold previous sum and carry
                    sum_pipe[i] <= sum_pipe[i];
                    carry_pipe[i+1] <= carry_pipe[i+1];
                end
            end

            // When result is valid, assemble output
            // Assemble result combinationally to avoid overwrites inside clocked block
            if (en_pipe[NUM_STAGES]) begin
                // Concatenate all sum slices (MSB slice highest index) and final carry_out
                // Using a temporary reg for combinational assembly
                reg [DATA_WIDTH:0] res_temp;
                res_temp = {carry_pipe[NUM_STAGES]};
                for (i = NUM_STAGES-1; i >= 0; i = i - 1)
                    res_temp = (res_temp << STG_WIDTH) | sum_pipe[i];
                result <= res_temp;
            end else begin
                result <= result;  // Hold previous result
            end

            // Output enable synchronized with last pipeline stage enable
            o_en <= en_pipe[NUM_STAGES];
        end
    end

endmodule