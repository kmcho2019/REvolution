module adder_pipe_64bit (
    input             clk,
    input             rst_n,
    input             i_en,
    input      [63:0] adda,
    input      [63:0] addb,
    output reg [64:0] result,
    output reg        o_en
);
    localparam STG_WIDTH = 8;
    localparam STAGES = 64 / STG_WIDTH;

    // Pipeline registers: operands, sums, carry, and enable
    reg [STG_WIDTH-1:0] adda_pipe   [0:STAGES-1];
    reg [STG_WIDTH-1:0] addb_pipe   [0:STAGES-1];
    reg [STG_WIDTH-1:0] sum_pipe    [0:STAGES-1];
    reg                 carry_pipe  [0:STAGES];  // carry_pipe[0] = carry-in for stage 0
    reg                 en_pipe     [0:STAGES];  // pipeline enable signals

    integer i;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (i = 0; i < STAGES; i = i + 1) begin
                adda_pipe[i]  <= {STG_WIDTH{1'b0}};
                addb_pipe[i]  <= {STG_WIDTH{1'b0}};
                sum_pipe[i]   <= {STG_WIDTH{1'b0}};
                carry_pipe[i] <= 1'b0;
                en_pipe[i]    <= 1'b0;
            end
            carry_pipe[STAGES] <= 1'b0;
            en_pipe[STAGES]    <= 1'b0;
            result             <= {65{1'b0}};
            o_en               <= 1'b0;
        end else begin
            // Stage 0: Register inputs and clear carry_in = 0
            if (i_en) begin
                adda_pipe[0] <= adda[STG_WIDTH*0 +: STG_WIDTH];
                addb_pipe[0] <= addb[STG_WIDTH*0 +: STG_WIDTH];
            end else begin
                adda_pipe[0] <= adda_pipe[0];
                addb_pipe[0] <= addb_pipe[0];
            end
            carry_pipe[0] <= 1'b0;
            en_pipe[0]    <= i_en;

            // Stages 1 to STAGES-1: register next operand slices delayed by pipeline latency
            for (i = 1; i < STAGES; i = i + 1) begin
                if (en_pipe[i-1]) begin
                    adda_pipe[i] <= adda[STG_WIDTH*i +: STG_WIDTH];
                    addb_pipe[i] <= addb[STG_WIDTH*i +: STG_WIDTH];
                end else begin
                    adda_pipe[i] <= adda_pipe[i];
                    addb_pipe[i] <= addb_pipe[i];
                end
                en_pipe[i] <= en_pipe[i-1];
            end

            // Compute sum and carry for each stage using registered operands and carry_in
            for (i = 0; i < STAGES; i = i + 1) begin
                {carry_pipe[i+1], sum_pipe[i]} <= adda_pipe[i] + addb_pipe[i] + carry_pipe[i];
            end

            // Propagate enable to output stage
            en_pipe[STAGES] <= en_pipe[STAGES-1];

            // Assemble result from sum pipes and final carry when output is enabled
            if (en_pipe[STAGES]) begin
                // Concatenate sum_pipe[STAGES-1] down to sum_pipe[0] plus final carry
                result <= {carry_pipe[STAGES],
                           sum_pipe[STAGES-1], sum_pipe[STAGES-2],
                           sum_pipe[STAGES-3], sum_pipe[STAGES-4],
                           sum_pipe[STAGES-5], sum_pipe[STAGES-6],
                           sum_pipe[STAGES-7], sum_pipe[0]};
                // Correct concatenation order:
                // Instead of listing sum_pipe[STAGES-7] to sum_pipe[0] manually,
                // do a generate or loop outside always block - since here STAGES=8, explicitly:
                result <= {carry_pipe[8],
                           sum_pipe[7], sum_pipe[6], sum_pipe[5], sum_pipe[4],
                           sum_pipe[3], sum_pipe[2], sum_pipe[1], sum_pipe[0]};
            end else begin
                result <= result; // hold previous result
            end

            o_en <= en_pipe[STAGES];
        end
    end

endmodule