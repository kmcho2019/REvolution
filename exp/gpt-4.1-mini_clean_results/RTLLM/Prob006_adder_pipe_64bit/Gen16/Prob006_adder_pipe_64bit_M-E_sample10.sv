module adder_pipe_64bit (
    input               clk,
    input               rst_n,
    input               i_en,
    input      [63:0]   adda,
    input      [63:0]   addb,
    output reg [64:0]   result,
    output reg          o_en
);

    localparam STAGES = 4;
    localparam STAGE_WIDTH = 16;

    // Pipeline registers for inputs and carry signals
    reg [63:0] adda_pipe [0:STAGES];
    reg [63:0] addb_pipe [0:STAGES];
    reg carry_in_pipe [0:STAGES];      // carry_in_pipe[0] = 0 at start
    reg [STAGES:0] en_pipe;            // pipeline enable signals

    // Partial sums and carry outs for each stage
    reg [STAGE_WIDTH-1:0] sum_pipe [0:STAGES-1];
    reg carry_out_pipe [0:STAGES-1];

    integer i;

    // Initialize pipeline registers and enable on reset
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            adda_pipe[0] <= 64'd0;
            addb_pipe[0] <= 64'd0;
            carry_in_pipe[0] <= 1'b0;
            en_pipe <= {(STAGES+1){1'b0}};
            for (i=0; i<STAGES; i=i+1) begin
                sum_pipe[i] <= {STAGE_WIDTH{1'b0}};
                carry_out_pipe[i] <= 1'b0;
                adda_pipe[i+1] <= 64'd0;
                addb_pipe[i+1] <= 64'd0;
                carry_in_pipe[i+1] <= 1'b0;
            end
            result <= 65'd0;
            o_en <= 1'b0;
        end else begin
            // Stage 0 input registers
            adda_pipe[0] <= adda;
            addb_pipe[0] <= addb;
            carry_in_pipe[0] <= 1'b0;       // initial carry_in = 0
            en_pipe[0] <= i_en;

            // Compute sum and carry-out for stage 0
            {carry_out_pipe[0], sum_pipe[0]} <= adda_pipe[0][15:0] + addb_pipe[0][15:0] + carry_in_pipe[0];

            // For pipeline stages 1 to STAGES-1
            for (i = 1; i < STAGES; i = i + 1) begin
                // Advance operands and carry_in down the pipeline
                adda_pipe[i] <= adda_pipe[i-1];
                addb_pipe[i] <= addb_pipe[i-1];
                carry_in_pipe[i] <= carry_out_pipe[i-1];
                en_pipe[i] <= en_pipe[i-1];
                // Compute sum and carry-out for this stage
                {carry_out_pipe[i], sum_pipe[i]} <= adda_pipe[i][STAGE_WIDTH*i +: STAGE_WIDTH] + 
                                                   addb_pipe[i][STAGE_WIDTH*i +: STAGE_WIDTH] + 
                                                   carry_in_pipe[i];
            end

            // Advance en_pipe final stage
            en_pipe[STAGES] <= en_pipe[STAGES-1];

            // Advance operands and carry_in registers for output timing
            adda_pipe[STAGES] <= adda_pipe[STAGES-1];
            addb_pipe[STAGES] <= addb_pipe[STAGES-1];
            carry_in_pipe[STAGES] <= carry_out_pipe[STAGES-1];

            // When output is valid, assemble final 65-bit result and set o_en
            if (en_pipe[STAGES]) begin
                result <= {carry_out_pipe[STAGES-1],
                           sum_pipe[STAGES-1],
                           sum_pipe[STAGES-2],
                           sum_pipe[STAGES-3],
                           sum_pipe[0]};
                o_en <= 1'b1;
            end else begin
                o_en <= 1'b0;
                result <= 65'd0;
            end
        end
    end

endmodule