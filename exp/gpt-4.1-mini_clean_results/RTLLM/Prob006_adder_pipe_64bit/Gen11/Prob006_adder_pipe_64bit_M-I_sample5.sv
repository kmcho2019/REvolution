module adder_pipe_64bit (
    input                  clk,
    input                  rst_n,
    input                  i_en,
    input      [63:0]      adda,
    input      [63:0]      addb,
    output reg [64:0]      result,
    output reg             o_en
);
    localparam STG_WIDTH = 8;
    localparam STAGES = 64 / STG_WIDTH;

    // Pipeline registers for operands, sums, and carry per stage
    reg [STG_WIDTH-1:0] adda_pipe   [0:STAGES-1];
    reg [STG_WIDTH-1:0] addb_pipe   [0:STAGES-1];
    reg [STG_WIDTH-1:0] sum_pipe    [0:STAGES-1];
    reg                 carry_pipe  [0:STAGES]; // carry_pipe[0] = carry-in to stage 0

    // Pipeline enable signals
    reg en_pipe [0:STAGES];

    integer i;

    // Pipeline registers shift on each clock
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset all pipeline registers and output
            for (i = 0; i < STAGES; i = i + 1) begin
                adda_pipe[i] <= {STG_WIDTH{1'b0}};
                addb_pipe[i] <= {STG_WIDTH{1'b0}};
                sum_pipe[i]  <= {STG_WIDTH{1'b0}};
                carry_pipe[i] <= 1'b0;
                en_pipe[i] <= 1'b0;
            end
            carry_pipe[STAGES] <= 1'b0; // final carry
            en_pipe[STAGES] <= 1'b0;
            result <= 0;
            o_en <= 1'b0;
        end else begin
            // Stage 0: Load inputs and reset carry_in for stage 0
            if (i_en) begin
                adda_pipe[0] <= adda[STG_WIDTH*0 +: STG_WIDTH];
                addb_pipe[0] <= addb[STG_WIDTH*0 +: STG_WIDTH];
            end else begin
                // Hold previous if no new input
                adda_pipe[0] <= adda_pipe[0];
                addb_pipe[0] <= addb_pipe[0];
            end
            carry_pipe[0] <= 1'b0; // carry-in to least significant 8 bits is zero
            en_pipe[0] <= i_en;

            // For stages 1 to STAGES-1: register operands from inputs delayed by pipeline stages
            for (i = 1; i < STAGES; i = i + 1) begin
                // Register operands for this stage inputs (slice of input operands delayed by i cycles)
                if (en_pipe[i-1]) begin
                    adda_pipe[i] <= adda[STG_WIDTH*i +: STG_WIDTH];
                    addb_pipe[i] <= addb[STG_WIDTH*i +: STG_WIDTH];
                end else begin
                    // Hold previous
                    adda_pipe[i] <= adda_pipe[i];
                    addb_pipe[i] <= addb_pipe[i];
                end
                // Propagate enable signal along pipeline
                en_pipe[i] <= en_pipe[i-1];
            end

            // Compute sum and carry for each stage from previous carry_pipe
            for (i = 0; i < STAGES; i = i + 1) begin
                {carry_pipe[i+1], sum_pipe[i]} <= adda_pipe[i] + addb_pipe[i] + carry_pipe[i];
            end

            // Propagate enable for output (after last stage)
            en_pipe[STAGES] <= en_pipe[STAGES-1];

            // Output assembly and enable
            if (en_pipe[STAGES]) begin
                // Concatenate sums and carry out in order
                // sum_pipe[0] is least significant 8 bits, sum_pipe[STAGES-1] is MS bits
                result <= {carry_pipe[STAGES], 
                           sum_pipe[STAGES-1], sum_pipe[STAGES-2], sum_pipe[STAGES-3], sum_pipe[STAGES-4],
                           sum_pipe[STAGES-5], sum_pipe[STAGES-6], sum_pipe[STAGES-7], sum_pipe[STAGES-8]};
                // Since STAGES=8, sum_pipe indices 7 down to 0:
                // Rewrite concisely:
                // {carry_pipe[8], sum_pipe[7], ..., sum_pipe[0]}
                // To avoid error, rewrite with generate later, but here manually:

                // We'll replace above with generate below.
            end else begin
                result <= result; // hold previous result
            end
            o_en <= en_pipe[STAGES];
        end
    end

    // Because concatenation in always block is awkward, do a combinational always to build result from sum_pipe and carry_pipe
    // Define a temporary register
    reg [64:0] result_comb;

    integer j;
    always @(*) begin
        // Start with zeros
        result_comb = {65{1'b0}};
        // Concatenate sums in order, LSB first at bits [7:0], etc.
        for (j = 0; j < STAGES; j = j + 1) begin
            result_comb[j*STG_WIDTH +: STG_WIDTH] = sum_pipe[j];
        end
        result_comb[64] = carry_pipe[STAGES];
    end

    // Synchronize result from combinational to sequential output only when output enabled
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            result <= 0;
        end else begin
            if (en_pipe[STAGES])
                result <= result_comb;
            else
                result <= result;
        end
    end

endmodule