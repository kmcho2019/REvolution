module adder_pipe_64bit (
    input               clk,
    input               rst_n,
    input               i_en,
    input       [63:0]  adda,
    input       [63:0]  addb,
    output reg  [64:0]  result,
    output reg          o_en
);

    localparam STAGE_WIDTH = 16;
    localparam NUM_STAGES = 4;

    // Pipeline registers for inputs and enable
    reg [63:0] adda_pipe [0:NUM_STAGES];
    reg [63:0] addb_pipe [0:NUM_STAGES];
    reg        i_en_pipe [0:NUM_STAGES];

    // Partial sums and carry between stages
    reg [STAGE_WIDTH-1:0] sum_stage [0:NUM_STAGES-1];
    reg carry_stage [0:NUM_STAGES];

    integer i;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (i = 0; i <= NUM_STAGES; i = i + 1) begin
                adda_pipe[i] <= 64'b0;
                addb_pipe[i] <= 64'b0;
                i_en_pipe[i] <= 1'b0;
                carry_stage[i] <= 1'b0;
            end
            for (i = 0; i < NUM_STAGES; i = i + 1)
                sum_stage[i] <= {STAGE_WIDTH{1'b0}};
            result <= 65'b0;
            o_en <= 1'b0;
        end else begin
            // Shift inputs and enable through pipeline stages
            adda_pipe[0] <= adda;
            addb_pipe[0] <= addb;
            i_en_pipe[0] <= i_en;
            for (i = 1; i <= NUM_STAGES; i = i + 1) begin
                adda_pipe[i] <= adda_pipe[i-1];
                addb_pipe[i] <= addb_pipe[i-1];
                i_en_pipe[i] <= i_en_pipe[i-1];
            end

            // Initialize carry_in for stage 0
            carry_stage[0] <= 1'b0;

            // Compute sums and carries for each pipeline stage
            for (i = 0; i < NUM_STAGES; i = i + 1) begin
                reg [STAGE_WIDTH-1:0] a_part;
                reg [STAGE_WIDTH-1:0] b_part;
                a_part = adda_pipe[i][(i+1)*STAGE_WIDTH-1 -: STAGE_WIDTH];
                b_part = addb_pipe[i][(i+1)*STAGE_WIDTH-1 -: STAGE_WIDTH];
                {carry_stage[i+1], sum_stage[i]} = a_part + b_part + carry_stage[i];
            end

            // Concatenate results: MSB carry + four 16-bit sums
            result <= {carry_stage[NUM_STAGES], sum_stage[NUM_STAGES-1], sum_stage[NUM_STAGES-2], sum_stage[1], sum_stage[0]};
            o_en <= i_en_pipe[NUM_STAGES];
        end
    end

endmodule