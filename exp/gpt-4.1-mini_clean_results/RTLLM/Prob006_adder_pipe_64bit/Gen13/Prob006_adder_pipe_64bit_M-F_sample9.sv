module adder_pipe_64bit (
    input               clk,
    input               rst_n,
    input               i_en,
    input      [63:0]   adda,
    input      [63:0]   addb,
    output reg [64:0]   result,
    output reg          o_en
);

    // Fixed constants for data width and stage width
    localparam DATA_WIDTH = 64;
    localparam STG_WIDTH  = 8;
    localparam STAGES     = DATA_WIDTH / STG_WIDTH; // 8 pipeline stages

    // Pipeline registers for sum outputs (per stage)
    reg [STG_WIDTH-1:0] sum_reg [0:STAGES-1];
    // Pipeline registers for carry signals (per stage), one extra for carry-in and carry-out
    reg                 carry_reg [0:STAGES];
    // Pipeline registers for enable signal to track pipeline progress
    reg                 en_pipe [0:STAGES];

    // Intermediate wires for stage additions (STG_WIDTH+1 bits to hold carry-out)
    wire [STG_WIDTH:0] stage_sum_w [0:STAGES-1];

    integer i;

    // Temporary register to assemble the output result
    reg [DATA_WIDTH:0] result_next;

    // Combinational adders for each pipeline stage
    generate
        genvar gi;
        for (gi = 0; gi < STAGES; gi = gi + 1) begin : gen_adders
            // Add STG_WIDTH-bit operands + carry_in from previous carry_reg
            assign stage_sum_w[gi] = adda[gi*STG_WIDTH +: STG_WIDTH] + addb[gi*STG_WIDTH +: STG_WIDTH] + carry_reg[gi];
        end
    endgenerate

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset all pipeline registers
            for (i = 0; i < STAGES; i = i + 1) begin
                sum_reg[i] <= {STG_WIDTH{1'b0}};
                carry_reg[i] <= 1'b0;
                en_pipe[i] <= 1'b0;
            end
            carry_reg[STAGES] <= 1'b0;
            en_pipe[STAGES] <= 1'b0;

            result <= {(DATA_WIDTH+1){1'b0}};
            o_en <= 1'b0;
        end else begin
            // Pipeline the enable signal through all stages
            en_pipe[0] <= i_en;
            for (i = 1; i <= STAGES; i = i + 1) begin
                en_pipe[i] <= en_pipe[i-1];
            end

            // Initialize carry-in for the first stage to zero
            carry_reg[0] <= 1'b0;

            // Register sum and carry outputs for each stage
            for (i = 0; i < STAGES; i = i + 1) begin
                sum_reg[i] <= stage_sum_w[i][STG_WIDTH-1:0];
                carry_reg[i+1] <= stage_sum_w[i][STG_WIDTH];
            end

            // Assemble the output result from pipeline sum registers and final carry out
            for (i = 0; i < STAGES; i = i + 1) begin
                result_next[i*STG_WIDTH +: STG_WIDTH] = sum_reg[i];
            end
            result_next[DATA_WIDTH] = carry_reg[STAGES];

            result <= result_next;

            // Output enable synchronized with pipeline delay
            o_en <= en_pipe[STAGES];
        end
    end

endmodule