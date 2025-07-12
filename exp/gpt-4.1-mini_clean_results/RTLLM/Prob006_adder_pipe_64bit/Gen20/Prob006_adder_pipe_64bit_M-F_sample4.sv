module adder_pipe_64bit #(
    parameter DATA_WIDTH = 64,
    parameter STG_WIDTH  = 8
)(
    input                         clk,
    input                         rst_n,
    input                         i_en,
    input      [DATA_WIDTH-1:0]   adda,
    input      [DATA_WIDTH-1:0]   addb,
    output reg [DATA_WIDTH:0]     result,
    output reg                    o_en
);

    // Number of pipeline stages
    localparam NUM_STAGES = DATA_WIDTH / STG_WIDTH;

    integer i;

    // Pipeline registers for operands per stage
    reg [STG_WIDTH-1:0] adda_pipe [0:NUM_STAGES-1];
    reg [STG_WIDTH-1:0] addb_pipe [0:NUM_STAGES-1];

    // Pipeline sum outputs per stage
    reg [STG_WIDTH-1:0] sum_pipe [0:NUM_STAGES-1];

    // Carry between stages: carry_pipe[0] is carry-in for stage 0
    reg carry_pipe [0:NUM_STAGES];

    // Pipeline enable signals per stage + output
    reg en_pipe [0:NUM_STAGES];

    // Sequential pipeline update
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset pipeline registers
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
            // Pipeline enable shift: load i_en at stage 0
            en_pipe[0] <= i_en;
            for (i = 1; i <= NUM_STAGES; i = i + 1) begin
                en_pipe[i] <= en_pipe[i-1];
            end

            // Operands pipeline shift and load
            // If i_en asserted, load input operands into stage 0; else shift operands down the pipeline
            if (i_en) begin
                for (i = 0; i < NUM_STAGES; i = i + 1) begin
                    adda_pipe[i] <= adda[i*STG_WIDTH +: STG_WIDTH];
                    addb_pipe[i] <= addb[i*STG_WIDTH +: STG_WIDTH];
                end
            end else begin
                for (i = NUM_STAGES-1; i > 0; i = i -1) begin
                    adda_pipe[i] <= adda_pipe[i-1];
                    addb_pipe[i] <= addb_pipe[i-1];
                end
                // Zero stage 0 operands when no new input
                adda_pipe[0] <= {STG_WIDTH{1'b0}};
                addb_pipe[0] <= {STG_WIDTH{1'b0}};
            end

            // Carry pipeline update
            // carry_pipe[0] = 0 on new input; else shift last carry forward
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
                    // Maintain previous sum and carry values when stage not enabled
                    sum_pipe[i] <= sum_pipe[i];
                    carry_pipe[i+1] <= carry_pipe[i+1];
                end
            end

            // Output enable and result update
            o_en <= en_pipe[NUM_STAGES];
            if (en_pipe[NUM_STAGES]) begin
                // Assemble final 65-bit result: MSB carry out + sums LSB to MSB in order
                // Do this here to avoid long combinational chain in always @(*)
                // Build result in a separate reg variable to assign once
                reg [DATA_WIDTH:0] assembled_result;
                assembled_result[DATA_WIDTH] = carry_pipe[NUM_STAGES];
                for (i = 0; i < NUM_STAGES; i = i + 1) begin
                    assembled_result[i*STG_WIDTH +: STG_WIDTH] = sum_pipe[i];
                end
                result <= assembled_result;
            end else begin
                result <= result;
            end
        end
    end

endmodule