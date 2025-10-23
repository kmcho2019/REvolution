module adder_pipe_64bit (
    input               clk,
    input               rst_n,
    input               i_en,
    input   [63:0]      adda,
    input   [63:0]      addb,
    output reg [64:0]   result,
    output reg          o_en
);

    localparam STG_WIDTH = 16;
    localparam STAGES = 64 / STG_WIDTH; // 4 stages

    reg [STG_WIDTH-1:0] adda_pipe [0:STAGES-1];
    reg [STG_WIDTH-1:0] addb_pipe [0:STAGES-1];
    reg carry_pipe [0:STAGES];
    reg en_pipe [0:STAGES];

    wire [STG_WIDTH:0] sum_stage [0:STAGES-1]; // carry_out + sum bits

    integer i;

    // Combinational adders for each stage
    genvar stage;
    generate
        for (stage = 0; stage < STAGES; stage = stage + 1) begin : gen_add
            assign sum_stage[stage] = adda_pipe[stage] + addb_pipe[stage] + carry_pipe[stage];
        end
    endgenerate

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset all pipeline registers and outputs
            for (i = 0; i < STAGES; i = i + 1) begin
                adda_pipe[i] <= 0;
                addb_pipe[i] <= 0;
                carry_pipe[i] <= 0;
                en_pipe[i] <= 0;
            end
            carry_pipe[STAGES] <= 0;
            en_pipe[STAGES] <= 0;
            result <= 0;
            o_en <= 0;
        end else begin
            // Stage 0: input slices and carry-in 0
            adda_pipe[0] <= adda[STG_WIDTH-1:0];
            addb_pipe[0] <= addb[STG_WIDTH-1:0];
            carry_pipe[0] <= 0;
            en_pipe[0] <= i_en;

            // Subsequent stages: shift slices and carry from previous sum
            for (i = 1; i < STAGES; i = i + 1) begin
                adda_pipe[i] <= adda[i*STG_WIDTH +: STG_WIDTH];
                addb_pipe[i] <= addb[i*STG_WIDTH +: STG_WIDTH];
                carry_pipe[i] <= sum_stage[i-1][STG_WIDTH];
                en_pipe[i] <= en_pipe[i-1];
            end

            // Final carry out and enable
            carry_pipe[STAGES] <= sum_stage[STAGES-1][STG_WIDTH];
            en_pipe[STAGES] <= en_pipe[STAGES-1];

            // Assemble the final 65-bit result
            result <= {carry_pipe[STAGES],
                       sum_stage[STAGES-1][STG_WIDTH-1:0],
                       sum_stage[STAGES-2][STG_WIDTH-1:0],
                       sum_stage[STAGES-3][STG_WIDTH-1:0],
                       sum_stage[STAGES-4][STG_WIDTH-1:0]};
            o_en <= en_pipe[STAGES];
        end
    end

endmodule