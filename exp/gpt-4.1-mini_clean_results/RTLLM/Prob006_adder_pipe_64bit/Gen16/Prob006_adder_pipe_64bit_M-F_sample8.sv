module adder_pipe_64bit #(
    parameter DATA_WIDTH = 64,
    parameter STG_WIDTH  = 8
)(
    input                         clk,
    input                         rst_n,
    input                         i_en,
    input       [DATA_WIDTH-1:0]  adda,
    input       [DATA_WIDTH-1:0]  addb,
    output reg  [DATA_WIDTH:0]    result,
    output reg                    o_en
);

    // Number of pipeline stages (assumed DATA_WIDTH divisible by STG_WIDTH)
    localparam NUM_STAGES = DATA_WIDTH / STG_WIDTH;

    integer i;

    // Pipeline registers for sum (per stage) and carry (between stages)
    reg [STG_WIDTH-1:0] sum_pipe [0:NUM_STAGES-1];
    reg carry_pipe [0:NUM_STAGES];

    // Pipeline registers for operands slices (loaded at stage 0)
    reg [STG_WIDTH-1:0] adda_slices [0:NUM_STAGES-1];
    reg [STG_WIDTH-1:0] addb_slices [0:NUM_STAGES-1];

    // Pipeline register for enable signal
    reg en_pipe [0:NUM_STAGES];

    // Register stage 0 operands slices on i_en
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
            result <= {(DATA_WIDTH+1){1'b0}};
            o_en <= 1'b0;
        end else begin
            // Load operand slices on i_en at stage 0
            if (i_en) begin
                for (i = 0; i < NUM_STAGES; i = i + 1) begin
                    adda_slices[i] <= adda[i*STG_WIDTH +: STG_WIDTH];
                    addb_slices[i] <= addb[i*STG_WIDTH +: STG_WIDTH];
                end
            end

            // Shift enable through pipeline stages
            en_pipe[0] <= i_en;
            for (i = 1; i <= NUM_STAGES; i = i + 1) begin
                en_pipe[i] <= en_pipe[i-1];
            end

            // Carry in to first stage is zero
            carry_pipe[0] <= 1'b0;

            // Perform addition stage-by-stage with carry propagation
            for (i = 0; i < NUM_STAGES; i = i + 1) begin
                if (en_pipe[i]) begin
                    {carry_pipe[i+1], sum_pipe[i]} <= adda_slices[i] + addb_slices[i] + carry_pipe[i];
                end else begin
                    // Hold previous values if no enable
                    sum_pipe[i] <= sum_pipe[i];
                    carry_pipe[i+1] <= carry_pipe[i+1];
                end
            end

            // Assemble the result from sum segments and final carry
            if (en_pipe[NUM_STAGES]) begin
                result <= {carry_pipe[NUM_STAGES], 
                    sum_pipe[NUM_STAGES-1],
                    sum_pipe[NUM_STAGES-2],
                    sum_pipe[NUM_STAGES-3],
                    sum_pipe[NUM_STAGES-4],
                    sum_pipe[NUM_STAGES-5],
                    sum_pipe[NUM_STAGES-6],
                    sum_pipe[NUM_STAGES-7],
                    sum_pipe[0]};
            end else begin
                result <= result;
            end

            // Output enable synchronized with pipeline completion
            o_en <= en_pipe[NUM_STAGES];
        end
    end

endmodule