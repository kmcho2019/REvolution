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
    reg [STG_WIDTH-1:0] adda_pipe [0:NUM_STAGES-1];
    reg [STG_WIDTH-1:0] addb_pipe [0:NUM_STAGES-1];

    // Sum output per stage
    reg [STG_WIDTH-1:0] sum_pipe [0:NUM_STAGES-1];

    // Carry signals between stages: carry_pipe[0] is carry-in for stage 0
    reg carry_pipe [0:NUM_STAGES];

    // Enable pipeline registers (one per stage plus output)
    reg en_pipe [0:NUM_STAGES];

    // Combinational register to assemble final result
    reg [DATA_WIDTH:0] assembled_result;

    // Pipeline registers update on clock
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset all pipeline registers and outputs
            for (i = 0; i < NUM_STAGES; i = i + 1) begin
                adda_pipe[i] <= {STG_WIDTH{1'b0}};
                addb_pipe[i] <= {STG_WIDTH{1'b0}};
                sum_pipe[i]  <= {STG_WIDTH{1'b0}};
                en_pipe[i]   <= 1'b0;
                carry_pipe[i] <= 1'b0;
            end
            carry_pipe[NUM_STAGES] <= 1'b0;
            en_pipe[NUM_STAGES] <= 1'b0;

            result <= {(DATA_WIDTH+1){1'b0}};
            o_en <= 1'b0;
        end else begin
            // Shift enable pipeline forward and load i_en at stage 0
            en_pipe[0] <= i_en;
            for (i = 1; i <= NUM_STAGES; i = i + 1) begin
                en_pipe[i] <= en_pipe[i-1];
            end

            // Shift operands through pipeline stages:
            // At stage 0, load inputs if i_en is asserted; else zero input slice
            if (i_en) begin
                for (i = 0; i < NUM_STAGES; i = i + 1) begin
                    adda_pipe[i] <= adda[i*STG_WIDTH +: STG_WIDTH];
                    addb_pipe[i] <= addb[i*STG_WIDTH +: STG_WIDTH];
                end
            end else begin
                // Shift operands down pipeline stages
                for (i = NUM_STAGES-1; i > 0; i = i - 1) begin
                    adda_pipe[i] <= adda_pipe[i-1];
                    addb_pipe[i] <= addb_pipe[i-1];
                end
                // Stage 0 operand slices zeroed if no new input
                adda_pipe[0] <= {STG_WIDTH{1'b0}};
                addb_pipe[0] <= {STG_WIDTH{1'b0}};
            end

            // Carry pipeline:
            // carry_pipe[0] = 0 when new input loaded, else shift from previous stage carry_pipe[NUM_STAGES]
            if (i_en) begin
                carry_pipe[0] <= 1'b0;
            end else begin
                carry_pipe[0] <= carry_pipe[NUM_STAGES];
            end

            // Compute sum and carry for each stage if enabled
            for (i = 0; i < NUM_STAGES; i = i + 1) begin
                if (en_pipe[i]) begin
                    {carry_pipe[i+1], sum_pipe[i]} <= adda_pipe[i] + addb_pipe[i] + carry_pipe[i];
                end else begin
                    // Hold previous sum and carry when not enabled
                    sum_pipe[i] <= sum_pipe[i];
                    carry_pipe[i+1] <= carry_pipe[i+1];
                end
            end

            // When the last pipeline stage is valid, output the result
            o_en <= en_pipe[NUM_STAGES];
            if (en_pipe[NUM_STAGES]) begin
                result <= assembled_result;
            end else begin
                result <= result;
            end
        end
    end

    // Assemble final 65-bit result: carry out as MSB, then sum_pipe[NUM_STAGES-1] down to sum_pipe[0]
    always @(*) begin
        integer idx;
        assembled_result = {carry_pipe[NUM_STAGES], sum_pipe[NUM_STAGES-1]};
        for (idx = NUM_STAGES-2; idx >= 0; idx = idx - 1) begin
            assembled_result = {assembled_result, sum_pipe[idx]};
        end
    end

endmodule