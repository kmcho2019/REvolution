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

    // Carry signals between stages: carry_pipe[0] is carry-in of stage 0
    reg carry_pipe [0:NUM_STAGES];

    // Enable pipeline registers
    reg en_pipe [0:NUM_STAGES];

    // Combinational wire to hold assembled result before assigning to output register
    reg [DATA_WIDTH:0] assembled_result;

    // Pipeline logic
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
            // Shift enable pipeline forward, load input enable at stage 0
            en_pipe[0] <= i_en;
            for (i = 1; i <= NUM_STAGES; i = i + 1) begin
                en_pipe[i] <= en_pipe[i-1];
            end

            // Shift operand slices pipeline forward
            // At stage 0, load inputs when enabled, else zero
            if (i_en) begin
                for (i = 0; i < NUM_STAGES; i = i + 1) begin
                    adda_pipe[i] <= adda[i*STG_WIDTH +: STG_WIDTH];
                    addb_pipe[i] <= addb[i*STG_WIDTH +: STG_WIDTH];
                end
            end else begin
                // Shift slices down pipeline stages
                // Start from last stage down to stage 1
                for (i = NUM_STAGES-1; i > 0; i = i - 1) begin
                    adda_pipe[i] <= adda_pipe[i-1];
                    addb_pipe[i] <= addb_pipe[i-1];
                end
                // Stage 0 holds zero slices if no new input
                adda_pipe[0] <= {STG_WIDTH{1'b0}};
                addb_pipe[0] <= {STG_WIDTH{1'b0}};
            end

            // Carry-in to stage 0 is zero when new inputs arrive; otherwise shift carry
            if (i_en) begin
                carry_pipe[0] <= 1'b0;
            end else begin
                carry_pipe[0] <= carry_pipe[0];
            end

            // Compute sum and carry for each stage if enabled
            for (i = 0; i < NUM_STAGES; i = i + 1) begin
                if (en_pipe[i]) begin
                    {carry_pipe[i+1], sum_pipe[i]} <= adda_pipe[i] + addb_pipe[i] + carry_pipe[i];
                end else begin
                    // Hold previous values when not enabled
                    sum_pipe[i] <= sum_pipe[i];
                    carry_pipe[i+1] <= carry_pipe[i+1];
                end
            end

            // Assemble the final result combinationally based on sum_pipe and carry_pipe
            // This must happen after sum_pipe and carry_pipe are updated (i.e., next clock cycle)
            // We'll do this in a combinational block below

            // Update output result and enable when final stage is valid
            o_en <= en_pipe[NUM_STAGES];
            if (en_pipe[NUM_STAGES]) begin
                result <= assembled_result;
            end else begin
                result <= result;
            end
        end
    end

    // Combinational block to assemble final result after all stages
    always @(*) begin
        integer idx;
        reg [DATA_WIDTH:0] temp_result;
        temp_result = {carry_pipe[NUM_STAGES], {DATA_WIDTH{1'b0}}};

        // Concatenate sum_pipe[NUM_STAGES-1] (MSB) down to sum_pipe[0] (LSB)
        for (idx = NUM_STAGES-1; idx >= 0; idx = idx - 1) begin
            temp_result = (temp_result << STG_WIDTH) | sum_pipe[idx];
        end
        assembled_result = temp_result;
    end

endmodule