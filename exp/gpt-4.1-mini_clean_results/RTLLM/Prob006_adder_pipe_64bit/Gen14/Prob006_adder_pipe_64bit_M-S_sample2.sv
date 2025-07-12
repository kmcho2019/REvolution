module adder_pipe_64bit (
    input              clk,
    input              rst_n,
    input              i_en,
    input       [63:0] adda,
    input       [63:0] addb,
    output reg [64:0]  result,
    output reg         o_en
);

    localparam STG_BITS = 16;
    localparam NUM_STG  = 4;

    // Pipeline registers for operand slices
    reg [STG_BITS-1:0] adda_pipe  [0:NUM_STG-1];
    reg [STG_BITS-1:0] addb_pipe  [0:NUM_STG-1];

    // Sum registers per stage
    reg [STG_BITS-1:0] sum_pipe   [0:NUM_STG-1];

    // Carry registers between stages (NUM_STG+1)
    reg carry_pipe [0:NUM_STG];

    // Pipeline enable registers to track valid data
    reg en_pipe [0:NUM_STG];

    integer i;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset all pipeline registers and outputs
            for (i = 0; i < NUM_STG; i = i + 1) begin
                adda_pipe[i]  <= {STG_BITS{1'b0}};
                addb_pipe[i]  <= {STG_BITS{1'b0}};
                sum_pipe[i]   <= {STG_BITS{1'b0}};
                carry_pipe[i] <= 1'b0;
                en_pipe[i]    <= 1'b0;
            end
            carry_pipe[NUM_STG] <= 1'b0;
            en_pipe[NUM_STG]    <= 1'b0;
            result <= 65'b0;
            o_en   <= 1'b0;
        end else begin
            // Stage 0: load first 16 bits of inputs if enabled
            if (i_en) begin
                adda_pipe[0] <= adda[ 0 +: STG_BITS];
                addb_pipe[0] <= addb[ 0 +: STG_BITS];
            end else begin
                adda_pipe[0] <= adda_pipe[0];
                addb_pipe[0] <= addb_pipe[0];
            end
            carry_pipe[0] <= 1'b0; // carry-in to first stage is zero
            en_pipe[0]    <= i_en;

            // Load operand slices for stages 1..3 and propagate enable
            for (i = 1; i < NUM_STG; i = i + 1) begin
                if (en_pipe[i-1]) begin
                    adda_pipe[i] <= adda[i*STG_BITS +: STG_BITS];
                    addb_pipe[i] <= addb[i*STG_BITS +: STG_BITS];
                end else begin
                    adda_pipe[i] <= adda_pipe[i];
                    addb_pipe[i] <= addb_pipe[i];
                end
                en_pipe[i] <= en_pipe[i-1];
            end

            // Compute sum and carry for each stage
            for (i = 0; i < NUM_STG; i = i + 1) begin
                {carry_pipe[i+1], sum_pipe[i]} <= adda_pipe[i] + addb_pipe[i] + carry_pipe[i];
            end

            // Propagate enable to carry_pipe and final en_pipe
            en_pipe[NUM_STG] <= en_pipe[NUM_STG-1];

            // Assemble final 65-bit result when output is valid
            if (en_pipe[NUM_STG]) begin
                result <= {carry_pipe[NUM_STG],
                           sum_pipe[NUM_STG-1],
                           sum_pipe[NUM_STG-2],
                           sum_pipe[NUM_STG-3],
                           sum_pipe[0]};
            end else begin
                result <= result;
            end

            o_en <= en_pipe[NUM_STG];
        end
    end
endmodule